//
//  Reminder.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 28.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

struct Reminder: Codable, Hashable {
    var repeatPeriod: RepeatPeriod
    
    var pickerDate: Date
    
    var weekday: Int?
    
    var dateComponents: DateComponents {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .hour, .minute], from: pickerDate)
        
        switch self.repeatPeriod {
            
        case .daily:
            components.day = nil
            components.weekday = nil
            
        case .weekly:
            components.day = nil
            components.weekday = weekday
            
        case .monthly:
            components.weekday = nil
            if components.day == nil {
                components.day = 1
            }
        }
        
        return components
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
            print("dateComponents.weekday: \(dateComponents.weekday)")
            if dateComponents.weekday == nil {
                return "error: weekday in reminder is nil"
            } else if Calendar.current.weekdaySymbols.indices.contains(dateComponents.weekday!) {
                return "Every week on \(Calendar.current.weekdaySymbols[dateComponents.weekday!]) at \(dateStr)"
            } else {
                return "error: weekday in reminder is out of range!"
            }
        case .monthly:
            if dateComponents.day == nil {
                return "error: day in reminder is nil"
            } else {
                return "Every month on \(dateComponents.day!)th at \(dateStr)"
            }
        }
    }
    
    init(repeatPeriod: RepeatPeriod, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, weekday: Int? = nil) {
        self.repeatPeriod = repeatPeriod
        
        let dateComponents = DateComponents(day: day,
                                            hour: hour,
                                            minute: minute)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        self.pickerDate = date!// ?? Date()
        self.weekday = weekday
    }
}

extension Reminder {
    static let morningDailyReminder =
        Reminder(repeatPeriod: .daily, hour: 9, minute: 15)
    
    static let weeklyReminder =
        Reminder(repeatPeriod: .weekly, day: 3, hour: 11, minute: 14, weekday: 4)
    
    static let monthlyReminder =
        Reminder(repeatPeriod: .monthly, day: 3, hour: 10, minute: 44, weekday: 4)
}
