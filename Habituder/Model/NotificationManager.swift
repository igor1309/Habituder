//
//  NotificationManager.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//
///  https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate/1649501-usernotificationcenter
///
///  Handling Notifications and Notification-Related Actions | Apple Developer Documentation
///  https://developer.apple.com/documentation/usernotifications/handling_notifications_and_notification-related_actions
///
///  Declaring Your Actionable Notification Types | Apple Developer Documentation
///  https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types
///
///  Acting on responses - a free Hacking with Swift tutorial
///  https://www.hackingwithswift.com/read/21/3/acting-on-responses
///
///  Local Notifications in Swift 5 and iOS 13 with UNUSerNotificationCenter
///  https://medium.com/flawless-app-stories/local-notifications-in-swift-5-and-ios-13-with-unusernotificationcenter-190e654a5615
//
///  Implement LocalNotification in SwiftUI
///  https://velog.io/@wimes/SwiftUI%EC%97%90%EC%84%9C-LocalNotification-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-4sk60gjlbf
//

import UIKit

struct Notification: Identifiable, Hashable {
    var id: UUID
    var request: UNNotificationRequest
    var isRegistered: Bool
}

final class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    private var notifications = [Notification]()
    
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
    
    var count: Int { notifications.count }
    
    ///  есть ли незарегистрированные в UNUserNotificationCenter?
    var haveIssues: Bool {
        let totalRegistered = notifications.filter { $0.isRegistered }.count
        return count != totalRegistered
    }
    
    func allNotifications() -> [Notification] {
        notifications
    }
    
    func notificationsFor(id: UUID) -> [Notification] {
        notifications.filter { $0.id == id }
    }
    
    
    func haveIssues(id: UUID) -> Bool {
        let registered = notifications.filter { $0.id == id && $0.isRegistered }.count
        return notificationsFor(id: id).count != registered
    }
    
    func createNotification(for goal: Goal) {
        
        let center = UNUserNotificationCenter.current()
        
        //  MARK: how to deal with previous notifications?? delete? if many notifications for the goal??
        /// delete previous notifications with ID
        center.removePendingNotificationRequests(withIdentifiers: [goal.request.identifier])
        
        var isAdded = false
        /// add new notification
        center.add(goal.request) { error in
            if error == nil {
                print("notification with ID \(goal.request.identifier) added (ok)")
                isAdded = true
            } else {
                print("something went wrong with adding notification request")
            }
        }
        
        notifications.removeAll { $0.id == goal.id }
        notifications.append(Notification(id: goal.id, request: goal.request, isRegistered: isAdded))
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
            
            //  MARK: how to deal with previous notifications?? delete? if many notifications for the goal??
            /// delete previous notifications with ID
            center.removePendingNotificationRequests(withIdentifiers: [goal.request.identifier])
            
            var isAdded = false
            /// add new notification
            center.add(goal.request) { error in
                if error == nil {
                    print("notification with ID \(goal.request.identifier) added (ok)")
                    isAdded = true
                } else {
                    print("something went wrong with adding notification request")
                }
            }
            
            self.notifications.removeAll { $0.id == goal.id }
            self.notifications.append(Notification(id: goal.id, request: goal.request, isRegistered: isAdded))
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
}

//  Notification Actions
extension NotificationManager {
    
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

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
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

extension NotificationManager {
    /// https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types
    func registerNotificationCategories() {
        // Define the custom actions
        let remindLaterAction = UNNotificationAction(
            identifier: "REMIND_LATER",
            title: "Remind me later",
            options: UNNotificationActionOptions(rawValue: 0))
        
        let doneAction = UNNotificationAction(
            identifier: "DONE",
            title: "Done for today",
            options: UNNotificationActionOptions(rawValue: 0))
        
        let editAction = UNNotificationAction(
            identifier: "EDIT",
            title: "Edit",
            options: UNNotificationActionOptions.foreground)
        
        // Define the notification type
        let goalReminderCategory = UNNotificationCategory(
            identifier: "GOAL_REMINDER",
            actions: [remindLaterAction, doneAction, editAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction)
        
        // Register the notification type
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([goalReminderCategory])
        print("Notification Categories are set (registered).")
    }
}
