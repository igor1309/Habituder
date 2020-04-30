//
//  Reminder.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 28.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

struct Reminder: Codable, Hashable {
    var repeatPeriod: RepeatPeriod {
        didSet {
            cleanComponents()
        }
    }
    var dateComponents: DateComponents
}
    
extension Reminder {
    
    var date: Date {
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        return date ?? Date()
    }
    
    mutating private func cleanComponents() {
        switch self.repeatPeriod {
        case .daily:
            dateComponents.day = nil
            dateComponents.weekday = nil
        case .weekly:
            dateComponents.day = nil
            if dateComponents.weekday == nil {
                dateComponents.weekday = 0
            }
        case .monthly:
            dateComponents.weekday = nil
            if dateComponents.day == nil {
                dateComponents.day = 1
            }
        }
    }
    
    var description: String {
        guard dateComponents.hour != nil && dateComponents.minute != nil else {
            return "error: hour or minute in reminder is nil"
        }
        
        let positional = DateComponentsFormatter()
        positional.unitsStyle = .positional
        
        let dateStr = positional.string(from: DateComponents(hour: dateComponents.hour, minute: dateComponents.minute))!

        switch self.repeatPeriod {
        case .daily:
            return "Daily at \(dateStr)"
        case .weekly:
            if dateComponents.weekday == nil {
                return "error: weekday in reminder is nil"
            } else {
                return "Every week on \(Calendar.current.weekdaySymbols[dateComponents.weekday!]) at \(dateStr)"
            }
        case .monthly:
            if dateComponents.day == nil {
                return "error: day in reminder is nil"
            } else {
                return "Every month on \(dateComponents.day!)th at \(dateStr)"
            }
        }
    }
}

extension Reminder {
    static let morningDailyReminder = Reminder(
        repeatPeriod: .daily,
        dateComponents: DateComponents(hour: 9,
                                       minute: 15))
    
    static let weeklyReminder = Reminder(
        repeatPeriod: .weekly,
        dateComponents: DateComponents(day: 3,
                                       hour: 11,
                                       minute: 14,
                                       weekday: 4))
    
    static let monthlyReminder = Reminder(
        repeatPeriod: .monthly,
        dateComponents: DateComponents(day: 3,
                                       hour: 10,
                                       minute: 44,
                                       weekday: 4))
}
