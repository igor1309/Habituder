//
//  PermisionsNoteView.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 30.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import Combine

struct PermisionsNoteView: View {
    @ObservedObject var notificationStore = NotificationStore()
    
    var body: some View {
        Group {
            if notificationStore.permisionsNote != nil {
                VStack(alignment: .center, spacing: 16) {
                    Text(notificationStore.permisionsNote!)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.systemRed)
                        .font(.subheadline)
                    
                    Divider()
                    
                    Button("Open Notification Settings") {
                        self.openSettingsApp()
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
            self.notificationStore.updateRequestedSubject.send("Update")
        }
    }
    
    //    private func check() {
    //        notificationStore.updateRequestedSubject.send(UUID().uuidString)
    //    }
    
    /// Не идеально — это ассинхронное действие, поэтому результат проверки получается позже, чем guard (и последующий код). Нужно либо как-то прицеплять closure, либо формировать издателя чтобы сначала получить обновленное состояние настроек, и только потом открывать Настройки (или нет)
    private func openSettingsApp() {
        /// check settings
        notificationStore.updateRequestedSubject.send("Update")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            /// open Settings app only is notifications are not allowed
            guard self.notificationStore.permisionsNote != nil else { return }
            
            DispatchQueue.main.async {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingsURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsURL, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        UIApplication.shared.openURL(settingsURL as URL)
                    }
                }
            }
        }
    }
}

struct PermisionsNoteView_Previews: PreviewProvider {
    static var previews: some View {
        PermisionsNoteView()
            .environmentObject(NotificationStore())
            .environment(\.colorScheme, .dark)
    }
}
