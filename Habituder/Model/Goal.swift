//
//  Goal.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 21.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation
import UserNotifications

struct Goal: Identifiable, Codable {
    var id = UUID()
    
    var name: String
    var note: String
    //    var preferedPartOfDay: PartOfDay
    
    //  MARK: FIFNISH THIS
    //  … until I figure out reminder structure
    var reminder: Reminder
    //    var reminders: [Reminder]
}

/// Notification handling
extension Goal {
    func createNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            
            /// `Не уверен`, что в этом конкретном случае необходимо запрашивать настройки — ведь если notifications не разрешены, то add(request) выдаст ошибку
            /// `Apple`: Always check your app’s authorization status before scheduling local notifications. Users can change your app’s authorization settings at any time. They can also change the type of interactions allowed by your app—which may cause you to alter the number or type of notifications your app sends.
            guard settings.authorizationStatus == .authorized
                || settings.authorizationStatus == .provisional else {
                    print("notifications are not allowed")
                    return
            }
            
            /// delete previous notifications with ID
            center.removePendingNotificationRequests(withIdentifiers: [self.request.identifier])
            
            /// add new notification
            center.add(self.request) { error in
                if error == nil {
                    print("notification with ID \(self.request.identifier) added (ok)")
                } else {
                    print("something went wrong with adding notification request")
                }
            }
        }
    }
    
    private var request: UNNotificationRequest {
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminder.dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "\(name) (\(reminder.description))"
        content.body = note
        
        ///  The request combines the content and trigger, but also adds a unique identifier so you can edit or remove specific alerts later on. If you don’t want to edit or remove stuff, use UUID().uuidString to get a random identifier.
        //  let randomIdentifier = UUID().uuidString
        /// using Goal.id as identifier
        let identifier = id.uuidString
        
        return UNNotificationRequest(identifier: identifier/*randomIdentifier*/, content: content, trigger: trigger)
    }
}

extension Goal: Hashable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
}
