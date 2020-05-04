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

//  ---------------------------------------------------------------
//
//  this class is not used but saved as an example of using Combine
//
//  ---------------------------------------------------------------

final class OLDNotificationStore: ObservableObject {
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
    
    func removeAll() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
}
