//
//  NotificationRow.swift
//  Habituder
//
//  Created by Igor Malyarov on 04.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct NotificationRow: View {
    @EnvironmentObject var store: Store
    
    let index: Int
    let goal: Goal
    
    @Binding var selected: Int
    @Binding var showEditor: Bool
    
    init(index: Int, goal: Goal, selected: Binding<Int>, showEditor: Binding<Bool>) {
        self.index = index
        self.goal = goal
        self._selected = selected
        self._showEditor = showEditor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.name)
            
            Text("id: \(goal.identifier)")
                .foregroundColor(.secondary)
                .font(.footnote)
            
            Text(store.pendingNotificationsStr(for: goal))
                .foregroundColor(store.pendingNotificationsColor(for: goal))
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
        NotificationRow(index: 1, goal: Goal.testingGoals()[1], selected: .constant(1), showEditor: .constant(false))
    }
}
