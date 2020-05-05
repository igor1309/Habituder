//
//  Notification.swift
//  Habituder
//
//  Created by Igor Malyarov on 05.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import UserNotifications

struct Notification: Identifiable, Hashable {
    var id: UUID
    var request: UNNotificationRequest
    var isRegistered: Bool
}
