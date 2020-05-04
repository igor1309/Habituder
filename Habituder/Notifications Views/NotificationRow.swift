//
//  NotificationRow.swift
//  Habituder
//
//  Created by Igor Malyarov on 04.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct NotificationRow: View {
    @EnvironmentObject var goalStore: GoalStore
    
    @ObservedObject var goalNotifications: GoalNotifications
    
    var goal: Goal
    
    @Binding var selected: Int
    @Binding var showEditor: Bool
    
    init(goal: Goal, selected: Binding<Int>, showEditor: Binding<Bool>) {
        self.goal = goal
        self._selected = selected
        self._showEditor = showEditor
        self.goalNotifications = GoalNotifications(identifier: goal.identifier)
    }
    
    
    var index: Int { goalStore.goals.firstIndex(of: goal)! }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.name)
            
            Text("id: \(goal.identifier)")
                .foregroundColor(.secondary)
                .font(.footnote)
            
            Text(goalNotifications.pendingNotifications)
                .foregroundColor(goalNotifications.color)
                .font(.footnote)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.selected = self.index
            self.showEditor = true
        }
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRow(goal: Goal.testingGoals()[1], selected: .constant(1), showEditor: .constant(false))
    }
}
