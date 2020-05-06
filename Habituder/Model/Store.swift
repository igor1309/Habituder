//
//  Store.swift
//  Habituder
//
//  Created by Igor Malyarov on 05.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import SwiftPI
import UserNotifications
import Combine

final class Store: NSObject, ObservableObject {
    
    @Published private(set) var goals: [Goal] = []
    @Published var notifications: [Notification] = []
    
    var haveIssues: Bool {
        //    print("goals count:         \(goals.count)")
        //    print("notifications count: \(notifications.count)")
        return !goals.reduce(true, { $0 && isNotificationRegistered(for: $1) })
    }
    
    override init() {
        super.init()
        
        //  Notifications Delegate
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
}


// MARK: - Save + Load
extension Store {
    func save() {
        DispatchQueue.main.async {
            let filename = "goals.json"
            print("saving \(filename)…")
            saveJSONToDocDir(data: self.goals, filename: filename)
        }
    }
    
    func load() {
        //  load goals
        if let savedGoals: [Goal] = loadJSONFromDocDir("goals.json") {
            self.goals = savedGoals
        } else {
            self.goals = []//Goal.testingGoals()
            save()
        }
        
        //  load notifications
        loadNotificationsFromUNUserNotificationCenter()
    }
    
    func loadNotificationsFromUNUserNotificationCenter() {
        //  load notifications
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests()
            .receive(on: DispatchQueue.main)
            .sink {
                print("loading notifications from UNUserNotificationCenter…")
                self.parseNotificationRequests($0)
                print("loaded notifications count: \(self.notifications.count)")
        }
        .store(in: &cancellables)
    }
    
    func parseNotificationRequests(_ requests: [UNNotificationRequest]) {
        var notifications = [Notification]()
        for request in requests {
            guard let id = UUID(uuidString: request.content.userInfo["GOAL_ID"] as! String) else {
                print("error converting UserInfo for key GOAL_ID to UUID")
                break
            }
            
            let notification = Notification(id: id, request: request, isRegistered: true)
            notifications.append(notification)
        }
        
        self.notifications = notifications
    }
}

extension UNUserNotificationCenter {
    /// like in https://www.donnywals.com/using-promises-and-futures-in-combine/
    func getPendingNotificationRequests() -> Future<[UNNotificationRequest], Never> {
        return Future { promise in
            self.getPendingNotificationRequests { requests in
                promise(.success(requests))
            }
        }
    }
}


//  MARK: - Handling Goals
extension Store {
    
    func createNewGoal() {
        goals.insert(Goal(), at: 0)
        save()
        createNotification(for: goals[0])
    }
    
    func updateGoal(_ goal: Goal, with newValue: Goal) {
        guard let index = goals.firstIndex(of: goal) else {
            print("error: goal not found")
            return
        }
        
        goals[index] = newValue
        save()
        
        createNotification(for: goals[index])
    }
    
    func updateGoalWithIndex(_ goalIndex: Int, name: String, note: String, reminder: Reminder) {
        
        goals[goalIndex].name = name
        goals[goalIndex].note = note
        goals[goalIndex].reminder = reminder
        save()
        
        createNotification(for: goals[goalIndex])
    }
    
    func move(from source: IndexSet, to destination: Int) {
        goals.move(fromOffsets: source, toOffset: destination)
        save()
    }
    
    func remove(goal: Goal) {
        deleteNotification(id: goal.id)
        goals.removeAll { $0.id == goal.id }
        save()
    }
    
    func delete(at offsets: IndexSet) {
        for ix in offsets {
            deleteNotification(id: goals[ix].id)
        }
        
        goals.remove(atOffsets: offsets)
        save()
    }
    
    func appendTestingStore() {
        let testingGoals = Goal.testingGoals()
        goals.append(contentsOf: testingGoals)
        save()
        
        for goal in testingGoals {
            createNotification(for: goal)
        }
    }
    
    func sortByNextDate() {
        goals.sort(by: { $0.reminder.nextDate < $1.reminder.nextDate })
        save()
    }
}


//  MARK: - Goal and its Notification
extension Store {
    func isNotificationRegistered(for goal: Goal) -> Bool {
        //  MARK: В ЭТОЙ РЕАЛИЗАЦИИ НЕ УЧИТЫВАЕТСЯ, ЧТО МОЖЕТ БЫТЬ НЕСКОЛЬКО УВЕДОМЛЕНИЙ ДЛЯ ОДНОЙ GOAL
        guard let notification = notifications
            .first(where: { $0.id == goal.id }) else {
                return false
        }
        
        return notification.isRegistered
    }
    
    func pendingNotificationsStr(for goal: Goal) -> String {
        let notificationsForGoal = notifications.filter { $0.id == goal.id }
        guard notificationsForGoal.isNotEmpty else {
                return "ISSUE: reminder not registered"
        }
        
        let debugDescriptions = notificationsForGoal.map { $0.request.trigger.debugDescription }
        let debugDescriptionsStr = ListFormatter.localizedString(byJoining: debugDescriptions)
        return "reminder registered\ntrigger(s): \(debugDescriptionsStr)"
    }
    
    func pendingNotificationsColor(for goal: Goal) -> Color {
        hasPendingNotifications(for: goal)
            ? .secondary
            : .systemRed
    }
    
    func pendingNotificationsFont(for goal: Goal) -> Font {
        hasPendingNotifications(for: goal)
            ? .caption
            : .body
    }
    
    func hasPendingNotifications(for goal: Goal) -> Bool {
        let notificationsForGoal = notifications.filter { $0.id == goal.id }
        guard notificationsForGoal.isNotEmpty else {
                return false
        }
        
        return notificationsForGoal.reduce(true, { $0 && $1.isRegistered })
    }
}


//  MARK: - Notification handling
extension Store {
    
    func createNotification(for goal: Goal) {
        
        let center = UNUserNotificationCenter.current()
        
        //  MARK: how to deal with previous notifications?? delete? if many notifications for the goal??
        /// delete previous notifications with ID
        center.removePendingNotificationRequests(withIdentifiers: [goal.request.identifier])
        
        //  MARK: чей ID здесь нужно использовать? какие notifications будут удаляться при отложении на попозже?
        notifications.removeAll { $0.id == goal.id }
        
        /// add new notification
        center.add(goal.request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    print("notification with ID \(goal.request.identifier) added (ok)")
                    self.notifications.append(Notification(id: goal.id, request: goal.request, isRegistered: true))
                } else {
                    print("somegoal went wrong with adding notification request")
                    self.notifications.append(Notification(id: goal.id, request: goal.request, isRegistered: false))
                }
            }
        }
    }
    
    /// `Не уверен`, что в этом конкретном случае создания напоминания необходимо запрашивать настройки — ведь если notifications не разрешены, то add(request) просто выдаст ошибку. НО: `Apple`: Always check your app’s authorization status before scheduling local notifications. Users can change your app’s authorization settings at any time. They can also change the type of interactions allowed by your app—which may cause you to alter the number or type of notifications your app sends.
    /// поэтому сохраняю эту версию функции
    func createNotificationOLD(for goal: Goal) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            
            guard settings.authorizationStatus == .authorized
                || settings.authorizationStatus == .provisional else {
                    print("notifications are not allowed")
                    return
            }
            
            //  MARK: how to deal with previous notifications?? delete? if many notifications for the thing??
            /// delete previous notifications with ID
            center.removePendingNotificationRequests(withIdentifiers: [goal.request.identifier])
            
            //  MARK: чей ID здесь нужно использовать? какие notifications будут удаляться при отложении на попозже?
            self.notifications.removeAll { $0.id == goal.id }
            
            /// add new notification
            center.add(goal.request) { error in
                if error == nil {
                    print("notification with ID \(goal.request.identifier) added (ok)")
                    DispatchQueue.main.async {
                        self.notifications.append(Notification(id: goal.id, request: goal.request, isRegistered: true))
                    }
                } else {
                    print("something went wrong with adding notification request")
                    DispatchQueue.main.async {
                        self.notifications.append(Notification(id: goal.id, request: goal.request, isRegistered: false))
                    }
                }
            }
        }
    }
    
    
    func deleteNotification(id: UUID) {
        guard let notification = notifications.first(where: { $0.id == id }) else {
            print("can't delete notification - no notifications with ID \(id.uuidString)")
            return
        }
        
        notifications.removeAll(where: { $0.id == id })
        
        let center = UNUserNotificationCenter.current()
        
        /// delete notifications with ID
        center.removePendingNotificationRequests(withIdentifiers: [notification.request.identifier])
        center.removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
    }
    
    func deleteNotification(_ notification: Notification) {
        guard notifications.first(where: { $0.id == notification.id }) != nil else {
            print("can't delete notification - no notifications with ID \(notification.id.uuidString)")
            return
        }
        
        notifications.removeAll(where: { $0.id == notification.id })
        
        let center = UNUserNotificationCenter.current()
        
        /// delete notifications with ID
        center.removePendingNotificationRequests(withIdentifiers: [notification.request.identifier])
        center.removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
    }
    
    func removeAll() {
        notifications = []
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        print("all notifications removed")
    }

    func notificationsFor(id: UUID) -> [Notification] {
        notifications.filter { $0.id == id }
    }

}


//  MARK: - Notification Actions
extension Store {
    
    func goalReminderForegroundAction(goalID: UUID){
        print("TBD: goalReminderForegroundAction for goal with id \(goalID.uuidString)")
    }
    
    func goalReminderActionDefault(goalID: UUID) {
        print("TBD: goalReminderActionDefault for goal with id \(goalID.uuidString)")
    }
    
    func goalReminderActionDismiss(goalID: UUID) {
        print("TBD: goalReminderActionDismiss for goal with id \(goalID.uuidString)")
    }
    
    func goalReminderActionPostpone(goalID: UUID) {
        print("TBD: goalReminderActionPostpone for goal with id \(goalID.uuidString)")
    }
    
    func goalReminderActionDone(goalID: UUID){
        print("TBD: goalReminderActionDone for goal with id \(goalID.uuidString)")
    }
    
    func goalReminderActionEdit(goalID: UUID){
        print("TBD: goalReminderActionEdit for goal with id \(goalID.uuidString)")
    }
}


//  MARK: - User Notification Center Delegate
extension Store: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        #if DEBUG
        print("userNotificationCenter didReceive notification")
        #endif
        
        // Get the Goal ID from the original notification.
        let userInfo = response.notification.request.content.userInfo
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        
        if categoryIdentifier == "GOAL_REMINDER" {
            // Retrieve the goal details
            if let goalID = UUID(uuidString: userInfo["GOAL_ID"] as! String) {
                
                // Perform the task associated with the action.
                switch response.actionIdentifier {
                    
                case UNNotificationDefaultActionIdentifier:
                    // the user swiped to unlock
                    print("Default identifier")
                    goalReminderActionDefault(goalID: goalID)
                    break
                    
                case UNNotificationDismissActionIdentifier:
                    // the user swiped to unlock
                    print("Dismiss identifier")
                    goalReminderActionDismiss(goalID: goalID)
                    break
                    
                case "REMIND_LATER":
                    goalReminderActionPostpone(goalID: goalID)
                    break
                    
                case "DONE":
                    goalReminderActionDone(goalID: goalID)
                    break
                    
                case "EDIT":
                    goalReminderActionEdit(goalID: goalID)
                    break
                    
                default:
                    break
                }
            }
        } else {
            // Handle other notification types...
        }
        
        
        // Always call the completion handler when done
        completionHandler()
    }
    
    ///  handle a notification that arrived while the app was running in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        #if DEBUG
        print("userNotificationCenter willPresent foreground notification")
        #endif
        
        let userInfo = notification.request.content.userInfo
        let categoryIdentifier = notification.request.content.categoryIdentifier
        
        if categoryIdentifier == "GOAL_REMINDER" {
            // Retrieve the goal details
            if let goalID = UUID(uuidString: userInfo["GOAL_ID"] as! String) {
                
                // process notification recieved in Foreground
                goalReminderForegroundAction(goalID: goalID)
                
                // Play a sound to let the user know about the invitation.
                print("Test Foreground: \(notification.request.identifier)")
                completionHandler([.alert, .sound])
                return
            }
        } else {
            // Handle other notification types...
        }
        
        //  MARK: - А ВОТ ЭТО ЗАЧЕМ?? и почему так?
        // Don't alert the user for other types.
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
}

