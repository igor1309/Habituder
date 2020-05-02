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
    
    @Published /*private(set)*/ var goals: [Goal] {
        didSet {
            save()
        }
    }
    
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
        goals[0].createNotification()
    }
    
    func appendTestingStore() {
        goals = goals + Goal.testingGoals()
        for goal in goals {
            goal.createNotification()
        }
    }

    func createNew() {
        //  MARK: hack to make Published work with didSet in array
        //  https://forums.developer.apple.com/thread/130692
        //        goalStore.goals = [Goal.empty] + goalStore.goals
        
        //MARK: NOTIFICATIONS!!!!!!!
        //
        let empty = Goal(name: "<New Goal>",
                         note: "<Goal Note>",
                         reminder: Reminder(repeatPeriod: .daily,
                                            hour: 9,
                                            minute: 17))
        goals.insert(empty, at: 0)
        goals[0].createNotification()
    }
    
    func remove(goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        goals.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        //MARK: NOTIFICATIONS!!!!!!!
        //
        goals.remove(atOffsets: offsets)
    }
    

}
