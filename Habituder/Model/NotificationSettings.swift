//
//  NotificationSettings.swift
//  Habituder
//
//  Created by Igor Malyarov on 05.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import UserNotifications
import Combine

final class NotificationSettings: ObservableObject {
    
    @Published var hasPermissions: Bool = true
    
    var permisionsNote: String? {
        if hasPermissions {
            return nil
        } else {
            // point user to settings
            return "If you want to recieve notifications please allow them in Settings"
        }
    }
    
    var requestedUpdateSubject = PassthroughSubject<String, Never>()
    var openSettingsAppSubject = PassthroughSubject<String, Never>()
    
    init() {
        let center = UNUserNotificationCenter.current()
        
        requestedUpdateSubject
            .flatMap { _ in
                center.notificationsAllowed()
        }
        .receive(on: DispatchQueue.main)
        .sink { self.hasPermissions = $0 }
        .store(in: &cancellables)
        
        openSettingsAppSubject
            .flatMap { _ in
                center.notificationsAllowed()
        }
        .receive(on: DispatchQueue.main)
        .sink {
            guard !$0 else { return }
            self.openSettingsApp()
        }
        .store(in: &cancellables)
        
        requestedUpdateSubject.send("Update")
        
        registerNotificationCategories()
    }
    
    private func openSettingsApp() {
        /// open Settings app only if notifications are not allowed
        guard !hasPermissions else { return }

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
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
}


/// https://www.donnywals.com/using-promises-and-futures-in-combine/
extension UNUserNotificationCenter {
    
    func notificationsAllowed() -> AnyPublisher<Bool, Never> {
        UNUserNotificationCenter.current().getNotificationSettings()
            .flatMap { settings -> AnyPublisher<Bool, Never> in
                switch settings.authorizationStatus {
                case .denied:
                    return Just(false)
                        .eraseToAnyPublisher()
                case .notDetermined:
                    /// .provisional to deliver quietly
                    return UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .sound, .badge, .provisional])
                        .replaceError(with: false)
                        .eraseToAnyPublisher()
                default:
                    return Just(true)
                        .eraseToAnyPublisher()
                }
        }
        .eraseToAnyPublisher()
    }
    
    func getNotificationSettings() -> Future<UNNotificationSettings, Never> {
        return Future { promise in
            self.getNotificationSettings { settings in
                promise(.success(settings))
            }
        }
    }
    
    func requestAuthorization(options: UNAuthorizationOptions) -> Future<Bool, Error> {
        return Future { promise in
            self.requestAuthorization(options: options) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(result))
                }
            }
        }
    }
}


//  Register Notification Categories
extension NotificationSettings {
    /// https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types
    func registerNotificationCategories() {
        // Define the custom actions
        let remindLaterAction = UNNotificationAction(
            identifier: "REMIND_LATER",
            title: "Remind me later",
            options: UNNotificationActionOptions(rawValue: 0))
        
        let doneAction = UNNotificationAction(
            identifier: "DONE",
            title: "Done for today",
            options: UNNotificationActionOptions(rawValue: 0))
        
        let editAction = UNNotificationAction(
            identifier: "EDIT",
            title: "Edit",
            options: UNNotificationActionOptions.foreground)
        
        // Define the notification type
        let goalReminderCategory = UNNotificationCategory(
            identifier: "GOAL_REMINDER",
            actions: [remindLaterAction, doneAction, editAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction)
        
        // Register the notification type
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([goalReminderCategory])
        print("Notification Categories are set (registered).")
    }
}

