//
//  testingGoals.swift
//  Habituder
//
//  Created by Igor Malyarov on 05.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

extension Goal {
    static func testingGoals() -> [Goal] {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(minute: 7), to: Date())!
        
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour: Int = components.hour!
        let minute: Int = components.minute!
        
        let reminder0 = /*Reminder.dailyReminder*/ Reminder(repeatPeriod: .daily, hour: hour, minute: minute - 10) //+ 3)
        
        let reminder1 = Reminder(repeatPeriod: .daily, hour: 11, minute: 30)// Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 6)
        
        let reminder2 = Reminder(repeatPeriod: .weekly, hour: 11, minute: 10, weekday: 3)// Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 9)
        
        let reminder3 = Reminder(repeatPeriod: .daily, hour: 10, minute: 10)// Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 12)
        
        let reminder4 = Reminder(repeatPeriod: .monthly, day: 6, hour: 10, minute: 10)// Reminder(repeatPeriod: .daily, hour: hour, minute: minute + 12)
        
        return [
            Goal(name: "Daily Coding",
                 note: "Train your brain!",
                 reminder: reminder0),
            Goal(name: "Meditation",
                 note: "You know, the morning one, or during your lunch hour, or whatever time works for you.",
                 reminder: reminder1),
            Goal(name: "Book reading",
                 note: "Fiction please!",
                 reminder: reminder2),
            Goal(name: "Time with Kid",
                 note: "Some Extra",
                 reminder: reminder3),
            Goal(name: "Another Goal",
                 note: "No note here",
                 reminder: reminder4)
        ]
    }
}
