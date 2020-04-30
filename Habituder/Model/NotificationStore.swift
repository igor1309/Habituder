//
//  NotificationStore.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 29.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation
import UserNotifications
import Combine

final class NotificationStore: ObservableObject {
    
    @Published var permisionsNote: String?
    
    var updateRequestedSubject = PassthroughSubject<String, Never>()
    
    init() {
        updateRequestedSubject
            .flatMap {_ in
                UNUserNotificationCenter.current().getNotificationSettings()
                    .flatMap { settings -> AnyPublisher<Bool, Never> in
                        switch settings.authorizationStatus {
                        case .denied:
                            return Just(false)
                                .eraseToAnyPublisher()
                        case .notDetermined:
                            /// .provisional to deliver quietly
                            return UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .provisional])
                                .replaceError(with: false)
                                .eraseToAnyPublisher()
                        default:
                            return Just(true)
                                .eraseToAnyPublisher()
                        }
                }
        }
        .sink(receiveValue: { hasPermissions in
            if !hasPermissions {
                DispatchQueue.main.async {
                    // point user to settings
                    self.permisionsNote = "If you want to recieve notifications please allow them in Settings"
                }
            } else {
                DispatchQueue.main.async {
                    self.permisionsNote = nil
                }
            }
        })
            .store(in: &cancellables)
        
        updateRequestedSubject.send("Update")
    }
    
    private var cancellables = [AnyCancellable]()
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
}


/// https://www.donnywals.com/using-promises-and-futures-in-combine/
extension UNUserNotificationCenter {
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

