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
    
    @Published private(set) var goals: [Goal]
    //    { didSet { save() } }
    
    init() {
        if let savedGoals: [Goal] = loadJSONFromDocDir("goals.json") {
            self.goals = savedGoals
        } else {
            self.goals = Goal.testingGoals()
            save()
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
        
        goals[index].createNotification()
    }
    
    func update(goalIndex: Int, name: String, note: String, reminder: Reminder) {
        
        goals[goalIndex].name = name
        goals[goalIndex].note = note
        goals[goalIndex].reminder = reminder
        save()
        
        goals[goalIndex].createNotification()
    }
    
    func appendTestingStore() {
        goals = goals + Goal.testingGoals()
        save()

        for goal in goals {
            goal.createNotification()
        }
    }

    func createNew() {
        let empty = Goal(name: "<New Goal>",
                         note: "<Goal Note>",
                         reminder: Reminder(repeatPeriod: .daily,
                                            hour: 9,
                                            minute: 17))
        goals.insert(empty, at: 0)
        goals[0].createNotification()
        save()
    }
    
    func remove(goal: Goal) {
        goal.deleteNotification()
        goals.removeAll { $0.id == goal.id }
        save()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        goals.move(fromOffsets: source, toOffset: destination)
        save()
    }
    
    func delete(at offsets: IndexSet) {
        for ix in offsets {
            goals[ix].deleteNotification()
        }
        
        goals.remove(atOffsets: offsets)
        save()
    }
}
