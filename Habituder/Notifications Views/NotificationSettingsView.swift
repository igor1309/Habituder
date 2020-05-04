//
//  NotificationSettingsView.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct NotificationSettingsView: View {
    @ObservedObject var notificationSettings = NotificationSettings()
    
    var body: some View {
        Group {
            if notificationSettings.permisionsNote != nil {
                VStack(alignment: .center, spacing: 16) {
                    Text(notificationSettings.permisionsNote!)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.systemRed)
                        .font(.subheadline)
                    
                    Divider()
                    
                    Button("Open Notification Settings") {
                        self.notificationSettings.requestedUpdateSubject.send("update")
                        self.notificationSettings.openSettingsAppSubject.send("update")
                    }
                    .foregroundColor(.accentColor)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondarySystemBackground))
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                EmptyView()
            }
        }
        .onAppear {
            self.notificationSettings.requestedUpdateSubject.send("Update")
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            NotificationSettingsView()
        }
        .environment(\.colorScheme, .dark)
    }
}
