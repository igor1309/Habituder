//
//  NotificationStore.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation
import SwiftUI
import UserNotifications
import Combine

final class NotificationStore: ObservableObject {
    @Published var qty: Int = 0
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests()
            .receive(on: DispatchQueue.main)
            .sink {
                self.qty = $0.count
        }
        .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
}

extension UNUserNotificationCenter {
    /// like in https://www.donnywals.com/using-promises-and-futures-in-combine/
    func getPendingNotificationRequests() -> Future<[UNNotificationRequest], Never> {
        return Future { promise in
            self.getPendingNotificationRequests { requests in
                promise(.success(requests))
            }
        }
    }
}

