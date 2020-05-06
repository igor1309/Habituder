//
//  PendingNotificationsViewOLDOLD.swift
//  Habituder
//
//  Created by Igor Malyarov on 06.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

//  MARK: using class NotificationSettings
//
struct PendingNotificationsViewOLD: View {
    @EnvironmentObject var store: Store
    @ObservedObject var goalNotifications: GoalNotifications
    
    var goal: Goal
    
    init(goal: Goal) {
        self.goal = goal
        self.goalNotifications = GoalNotifications(identifier: goal.identifier)
    }
    
    var body: some View {
        Section(header: Text("Pending Notifications (OLD)".uppercased()),
                footer: Text("Using class NotificationSettings")
        ) {
            HStack {
                Text(goalNotifications.pendingNotifications)
                    .foregroundColor(goalNotifications.color)
                    .font(goalNotifications.font)
                
                if goalNotifications.isEmpty != nil {
                    if goalNotifications.isEmpty! {
                        Spacer()
                        
                        Button("FIX") {
                            self.fixNotification()
                        }
                    }
                }
            }
            
            NotificationSettingsView()
        }
    }
    
    private func fixNotification() {
        store.createNotification(for: goal)
    }
}

struct PendingNotificationsViewOLD_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            PendingNotificationsViewOLD(goal: Goal.testingGoals()[1])
        }
        .environmentObject(Store())
        .environment(\.colorScheme, .dark)
    }
}
