//
//  AllNotificationsView.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct AllNotificationsView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var goalStore: GoalStore
    
    @State private var showEditor = false
    @State private var selected: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                if goalStore.anyIssues {
                    Section(header: Text("Issues".uppercased())) {
                        if goalStore.notificationManager.haveIssues {
                            Text("Some notifications not registered")
                                .foregroundColor(.systemRed)
                        }
                        
                        if goalStore.haveIssues {
                            Text("Goals: \(goalStore.goals.count), with reminders: \(goalStore.notificationManager.count)")
                                .foregroundColor(.systemRed)
                        }
                    }
                } else {
                    Text("All good, no issues")
                }
                
                if goalStore.notificationManager.count > 0 {
                    Section(footer: Text("Delete all pending and delivered notifications.")) {
                        Button("Delete All Notifications") {
                            self.goalStore.notificationManager.removeAll()
                            print("self.goalStore.notificationManager.allNotifications(): \(self.goalStore.notificationManager.allNotifications())")
                            print("self.goalStore.notificationManager.count: \(self.goalStore.notificationManager.count)")
                        }
                        .foregroundColor(.systemRed)
                    }
                }
                
                Section(header: Text("Notifications".uppercased())) {
                    if goalStore.notificationManager.count > 0 {
                        ForEach(goalStore.notificationManager.allNotifications(), id: \.self) { notification in
                            Text(notification.request.trigger.debugDescription)
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                    } else {
                        Text("No pending notifications.")
                            .foregroundColor(.secondary)
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
