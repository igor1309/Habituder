//
//  PendingNotificationsView.swift
//  Habituder
//
//  Created by Igor Malyarov on 06.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct PendingNotificationsView: View {
    @EnvironmentObject var store: Store
    
    var goal: Goal
    
    var body: some View {
        Section(header: Text("Pending Notifications (new)".uppercased()),
                footer: Text("Using Store")
        ) {
            HStack {
                Text(store.pendingNotificationsStr(for: goal))
                    .foregroundColor(store.pendingNotificationsColor(for: goal))
                    .font(store.pendingNotificationsFont(for: goal))
                
                if !store.hasPendingNotifications(for: goal) {
                    Spacer()
                    
                    Button("FIX") {
                        self.fixNotification()
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

struct PendingNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            PendingNotificationsView(goal: Goal.testingGoals()[1])
        }
        .environmentObject(Store())
        .environment(\.colorScheme, .dark)
    }
}
