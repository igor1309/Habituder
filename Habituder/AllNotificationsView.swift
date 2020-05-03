//
//  AllNotificationsView.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct NotificationRow: View {
    @ObservedObject var goalNotifications: GoalNotifications
    var goal: Goal
    
    init(goal: Goal) {
        self.goal = goal
        self.goalNotifications = GoalNotifications(identifier: goal.identifier)
    }
    
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
    }
}

struct AllNotificationsView: View {
    @EnvironmentObject var goalStore: GoalStore
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("TBD".uppercased())) {
                    Text("TBD: other registered notifications (to check the garbage).")
                        .foregroundColor(.systemRed)
                }
                
                Section(header: Text("Current Goals".uppercased())) {
                    ForEach(goalStore.goals) { goal in
                        NotificationRow(goal: goal)
                    }
                }
            }
            .navigationBarTitle("All Notifications")
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
