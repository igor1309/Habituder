//
//  GoalStore.swift
//  Habituder
//
//  Created by Igor Malyarov on 01.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import SwiftPI
import Combine

final class GoalStore: ObservableObject {
    
    @Published private(set) var goals = [Goal]()
    
    @Published var notificationManager = NotificationManager()
    
    var haveIssues: Bool {
        print("goals count \(goals.count)")
        print("notifications count: \(notificationManager.count)")
        let goalsNotificationsIssues: Bool = (goals.count != notificationManager.count)
        print("goalsNotificationsIssues: \(goalsNotificationsIssues)\n")
        return goalsNotificationsIssues
    }
    
    var anyIssues: Bool {
        notificationManager.haveIssues || haveIssues
    }
    
    init() {
        //  Notifications Delegate
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationManager.shared
        
        
        //  register Notification Categories
        notificationManager.registerNotificationCategories()
        
        
        //  load goals
        if let savedGoals: [Goal] = loadJSONFromDocDir("goals.json") {
            self.goals = savedGoals
        } else {
            self.goals = []//Goal.testingGoals()
            save()
        }
        
                
        //  load notifications
        center.getPendingNotificationRequests()
            .receive(on: DispatchQueue.main)
            .sink {
                print("\nloading notifications…\n")
                self.notificationManager.parseNotificationRequests($0)
                print("notificationManager.qty: \(self.notificationManager.count)")
        }
        .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
}

extension GoalStore {
    private func save() {
        DispatchQueue.main.async {
            let filename = "goals.json"
            print("saving \(filename)…")
            saveJSONToDocDir(data: self.goals, filename: filename)
        }
    }
    
    func update(goal: Goal, with newValue: Goal) {
        guard let index = goals.firstIndex(of: goal) else {
            print("error: goal not found")
            return
        }
        
        goals[index] = newValue
        save()
        
        notificationManager.createNotification(for: goals[index])
    }
    
    func update(goalIndex: Int, name: String, note: String, reminder: Reminder) {
        
        goals[goalIndex].name = name
        goals[goalIndex].note = note
        goals[goalIndex].reminder = reminder
        save()
        
        notificationManager.createNotification(for: goals[goalIndex])
    }
    
    func appendTestingStore() {
        goals = goals + Goal.testingGoals()
        save()
        
        for goal in goals {
            notificationManager.createNotification(for: goal)
        }
    }
    
    func createNew() {
        goals.insert(Goal(), at: 0)
        notificationManager.createNotification(for: goals[0])
        save()
    }
    
    func remove(goal: Goal) {
        notificationManager.deleteNotification(id: goal.id)
        goals.removeAll { $0.id == goal.id }
        save()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        goals.move(fromOffsets: source, toOffset: destination)
        save()
    }
    
    func delete(at offsets: IndexSet) {
        for ix in offsets {
            notificationManager.deleteNotification(id: goals[ix].id)
        }
        
        goals.remove(atOffsets: offsets)
        save()
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
