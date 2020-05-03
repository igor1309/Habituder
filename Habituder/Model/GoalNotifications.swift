//
//  GoalNotifications.swift
//  Habituder
//
//  Created by Igor Malyarov on 03.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

final class GoalNotifications: ObservableObject {
    
    @Published var pendingNotifications: String
    @Published var isEmpty: Bool?
    
    var color: Color {
        isEmpty == nil
            ? .clear
            : isEmpty! ? .systemRed : .secondary
    }
    
    var font: Font {
        isEmpty == nil
            ? .body
            : isEmpty! ? .body : .caption
    }
    
    private enum PendingRequestsError: Error { case empty }
    
    init(identifier: String) {
        self.pendingNotifications = ""
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(for: identifier)
            .tryMap { requests -> [String] in
                if requests.isEmpty {
                    throw PendingRequestsError.empty
                } else {
                    return requests.map { $0.trigger.debugDescription }
                }
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure:
                self.pendingNotifications = "ISSUE: reminder not registered"
                self.isEmpty = true
            case .finished:
                self.isEmpty = false
            }
        }, receiveValue: {
            self.pendingNotifications = "reminder registered\ntrigger(s): " + ListFormatter.localizedString(byJoining: $0)
        })
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
    func getPendingNotificationRequests(for identifier: String) -> Future<[UNNotificationRequest], Never> {
        return Future { promise in
            self.getPendingNotificationRequests { requests in
                promise(.success(requests.filter { $0.identifier == identifier}))
            }
        }
    }
}
