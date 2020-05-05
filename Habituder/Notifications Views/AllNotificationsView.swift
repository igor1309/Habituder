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
    @EnvironmentObject var store: Store
    @EnvironmentObject var notificationSettings: NotificationSettings
    
    @State private var showEditor = false
    @State private var selected: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                if store.haveIssues {
                    Section(header: Text("Issues".uppercased())) {
                        Text("Some notifications not registered")
                            .foregroundColor(.systemRed)
                    }
                } else {
                    Text("All good, no issues")
                }
                
                if store.goals.count > 0 {
                    Section(footer: Text("Delete all pending and delivered notifications.")) {
                        Button("Delete All Notifications") {
                            self.store.removeAll()
                            print("self.store.notifications: \(self.store.notifications)")
                            print("self.store.goals.count: \(self.store.goals.count)")
                        }
                        .foregroundColor(.systemRed)
                    }
                }
                
                Section(header: Text("Notifications".uppercased())) {
                    if store.notifications.count > 0 {
                        ForEach(store.notifications, id: \.self) { notification in
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
                    ForEach(store.goals.enumeratedArray(), id: \.element.id) { index, goal in
                        NotificationRow(index: index, goal: goal, selected: self.$selected, showEditor: self.$showEditor)
                    }
                }
            }
            .sheet(isPresented: $showEditor) {
                GoalEditor(goal: self.store.goals[self.selected], index: self.selected)
                    .environmentObject(self.store)
                    .environmentObject(self.notificationSettings)
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
            .environmentObject(Store())
            .environment(\.colorScheme, .dark)
    }
}
