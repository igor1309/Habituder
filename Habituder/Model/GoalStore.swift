//
//  GoalStore.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 21.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation
import Combine
import SwiftPI

final class GoalStore: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    
    /*@Published*/ private(set) var goals: [Goal] {
        didSet {
            save()
        }
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        if let saved: [Goal] = loadJSONFromDocDir("goals.json") {
            goals = saved
        } else {
            goals = GoalStore.testingStore()
            for goal in goals {
                goal.createNotification()
            }
            save()
        }
    }
}

/// funcs to handle goals as private(set)
extension GoalStore {
    func updateGoal(at index: Int, with newValue: Goal) {
        guard goals.indices.contains(index) else {
            print("can't update - no such index")
            return
        }
        
        goals[index] = newValue
        goals[index].createNotification()
    }
    
    func createNew() {
        //  MARK: hack to make Published work with didSet in array
        //  https://forums.developer.apple.com/thread/130692
        //        goalStore.goals = [Goal.empty] + goalStore.goals
        
        //MARK: NOTIFICATIONS!!!!!!!
        //
        let empty = Goal(name: "<New Goal>",
                         note: "<Goal Note>",
                         reminder: Reminder.morningDailyReminder)
        goals.insert(empty, at: 0)
        goals[0].createNotification()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        goals.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        //MARK: NOTIFICATIONS!!!!!!!
        //
        goals.remove(atOffsets: offsets)
    }
    
    func remove(at index: Int) {
        //MARK: NOTIFICATIONS!!!!!!!
        //
        goals.remove(at: index)
    }
    
    func appendTestingStore() {
        goals = goals + GoalStore.testingStore()
        for goal in goals {
            goal.createNotification()
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
}

extension GoalStore {
    static func testingStore() -> [Goal] {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(minute: 7), to: Date())!
        
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour: Int = components.hour!
        let minute: Int = components.minute!
        
        let reminder0 = Reminder(
            repeatPeriod: .daily,
            dateComponents: DateComponents(hour: hour, minute: minute + 3)
        )
        
        let reminder1 = Reminder(
            repeatPeriod: .daily,
            dateComponents: DateComponents(hour: hour, minute: minute + 6)
        )
        
        let reminder2 = Reminder(
            repeatPeriod: .daily,
            dateComponents: DateComponents(hour: hour, minute: minute + 9)
        )
        
        let reminder3 = Reminder(
            repeatPeriod: .daily,
            dateComponents: DateComponents(hour: hour, minute: minute + 12)
        )
        
        return [
            Goal(name: "Daily Coding",
                 note: "Train your brain!",
                 reminder: reminder0),
            Goal(name: "Meditation",
                 note: "You know, the morning one",
                 reminder: reminder1),
            Goal(name: "Book reading",
                 note: "Fiction please!",
                 reminder: reminder2),
            Goal(name: "Time with Kid",
                 note: "Some Extra",
                 reminder: reminder3)
        ]
    }
}
