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
    
    var reminder: Reminder
}

/// Notification handling
extension Goal {
    private var request: UNNotificationRequest {
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminder.dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "\(name)"
        content.body = "\(note)\n(\(reminder.description))"
        
        ///  The request combines the content and trigger, but also adds a unique identifier so you can edit or remove specific alerts later on. If you don’t want to edit or remove stuff, use UUID().uuidString to get a random identifier.
        //  let randomIdentifier = UUID().uuidString
        /// using Goal.id as identifier
        let identifier = id.uuidString
        
        return UNNotificationRequest(identifier: identifier/*randomIdentifier*/, content: content, trigger: trigger)
    }
    
    func createNotification() {
        let center = UNUserNotificationCenter.current()
        
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
    
    /// `Не уверен`, что в этом конкретном случае создания напоминания необходимо запрашивать настройки — ведь если notifications не разрешены, то add(request) просто выдаст ошибку. НО: `Apple`: Always check your app’s authorization status before scheduling local notifications. Users can change your app’s authorization settings at any time. They can also change the type of interactions allowed by your app—which may cause you to alter the number or type of notifications your app sends.
    /// поэтому сохраняю эту версию функции
    func createNotificationOLD() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            
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
}

extension Goal: Equatable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
}

extension Goal {
    static func testingGoals() -> [Goal] {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(minute: 7), to: Date())!
        
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour: Int = components.hour!
        let minute: Int = components.minute!
        
        let reminder0 = Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 3)
        
        let reminder1 = Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 6)
        
        let reminder2 = Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 9)
        
        let reminder3 = Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 12)
        
        return [
            Goal(name: "Daily Coding",
                 note: "Train your brain!",
                 reminder: reminder0),
            Goal(name: "Meditation",
                 note: "You know, the morning one",
                 reminder: reminder1),
            Goal(name: "Book reading",
                 note: "Fiction please!",
                 reminder: reminder2),
            Goal(name: "Time with Kid",
                 note: "Some Extra",
                 reminder: reminder3)
        ]
    }
}
