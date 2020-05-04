//
//  Goal.swift
//  Habituder
//
//  Created by Igor Malyarov on 01.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation
import UserNotifications

struct Goal: Identifiable, Codable {
    var id = UUID()
    
    var name: String = "New Goal"
    var note: String = "New Goal Note"
    
    var reminder: Reminder = .dailyReminder
}

/// Notification stuff
extension Goal {
    var identifier: String { id.uuidString }
    
    var request: UNNotificationRequest {
        //  ---------------------------------------------------------------
        //
        //  MARK: UNCOMMENT trigger AFTER TESTING
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminder.dateComponents, repeats: true)
        //  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        //
        //  ---------------------------------------------------------------
        
        let content = UNMutableNotificationContent()
        content.title = "\(name)"
        content.body = "\(note)\n(\(reminder.description))"
        content.categoryIdentifier = "GOAL_REMINDER"
        content.userInfo = ["GOAL_ID" : identifier]
        
        ///  The request combines the content and trigger, but also adds a unique identifier so you can edit or remove specific alerts later on. If you don’t want to edit or remove stuff, use UUID().uuidString to get a random identifier.
        //  let randomIdentifier = UUID().uuidString
        /// using Goal.id as identifier
        return UNNotificationRequest(identifier: identifier/*randomIdentifier*/, content: content, trigger: trigger)
    }
}

extension Goal: Equatable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
}
