//
//  GoalListRow.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

/// НЕ ИСПОЛЬЗУЕТСЯ ТАК КАК ПРИВОДИТ К ПОСТОЯННОЙ ИНИЦИАЛИЗАЦИИ GoalNotifications — и при создании списка и при вызове Detail View
struct GoalListRow: View {
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
            HStack(alignment: .firstTextBaseline) {
                Text(goal.name)
                    .foregroundColor(.systemOrange)
                
                Spacer()
                
                Text(goalNotifications.isEmpty == nil
                    ? ""
                    : goalNotifications.isEmpty!
                    ? "Error"
                    : goal.reminder.description)
                    .foregroundColor(goalNotifications.color)
                    .font(.caption)
            }
            
            Text(goal.note)
                .foregroundColor(.secondary)
                .font(.footnote)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.selected = self.index
            self.showEditor = true
        }
    }
}

