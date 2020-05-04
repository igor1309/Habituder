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
