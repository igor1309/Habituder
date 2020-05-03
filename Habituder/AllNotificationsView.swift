//
//  AllNotificationsView.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
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

struct AllNotificationsView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var goalStore: GoalStore
    
    @ObservedObject var notificationStore = NotificationStore()
    
    @State private var showEditor = false
    @State private var selected: Int = 0
    
    var haveIssues: Bool { return goalStore.goals.count != notificationStore.qty }
    
    var body: some View {
        NavigationView {
            Form {
                if haveIssues {
                    Section(header: Text("Issues".uppercased())) {
                        Text("Goals: \(goalStore.goals.count), Reminders: \(notificationStore.qty)")
                            .foregroundColor(.systemRed)
                    }
                }
                
                Section(header: Text("Current Goals".uppercased())) {
                    ForEach(goalStore.goals) { goal in
                        NotificationRow(goal: goal, selected: self.$selected, showEditor: self.$showEditor)
                    }
                }
            }
            .sheet(isPresented: $showEditor) {
                GoalEditor(goal: self.goalStore.goals[self.selected], index: self.selected)
                    .environmentObject(self.goalStore)
            }
            .navigationBarTitle("All Notifications")
            .navigationBarItems(trailing: Button("Done") {
                self.presentation.wrappedValue.dismiss()
            })
        }
    }
}

struct AllNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        AllNotificationsView()
            .environmentObject(GoalStore())
            .environment(\.colorScheme, .dark)
    }
}
