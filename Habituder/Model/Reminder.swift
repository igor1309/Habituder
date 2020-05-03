//
//  Reminder.swift
//  Habituder
//
//  Created by Igor Malyarov on 01.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

struct Reminder: Codable {
    var repeatPeriod: RepeatPeriod {
        didSet {
            switch repeatPeriod {
            case .daily:
                return
            case .weekly:
                if weekday == nil { weekday = 1 }
                return
            case .monthly:
                if day == nil { day = 1 }
                return
            }
        }
    }
    var pickerTime: Date
    var day: Int?
    var weekday: Int?
    
    init(repeatPeriod: RepeatPeriod,
         day: Int? = nil,
         hour: Int? = nil,
         minute: Int? = nil,
         weekday: Int? = nil) {
        
        self.repeatPeriod = repeatPeriod
        
        let dateComponents = DateComponents(hour: hour, minute: minute)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        self.pickerTime = date!
        
        self.day = day
        self.weekday = weekday
    }
}

extension Reminder {
    func toString() -> String {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: pickerTime)
        components.day = day
        components.weekday = weekday
        
        return components.toString()
    }
    
    var description: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: pickerTime)
        
        guard let timeString = formatter.string(from: components) else {
            return "unable to process reminder"
        }
        
        let timeStr = components.hour == 0 ? "00:" + timeString : timeString
        
        switch self.repeatPeriod {
        case .daily:
            return "Daily at \(timeStr)"
        case .weekly:
            guard weekday != nil else { return "error: weekday in reminder is nil" }
            return "Every \(Calendar.current.weekdaySymbols[weekday!]) at \(timeStr)"
        case .monthly:
            guard day != nil else { return "error: day in reminder is nil" }
            return "Every month on \(day!)th at \(timeStr)"
        }
    }
    
    var shortDescription: String {
        switch self.repeatPeriod {
        case .daily:
            return "Daily"
        case .weekly:
            guard weekday != nil else { return "error: weekday in reminder is nil" }
            return "Every \(Calendar.current.weekdaySymbols[weekday!])"
        case .monthly:
            guard day != nil else { return "error: day in reminder is nil" }
            return "Every month on \(day!)th"
        }
    }
    
    var dateComponents: DateComponents {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: pickerTime)
        
        switch self.repeatPeriod {
        case .daily:
            break
        case .weekly:
            guard weekday != nil else { fatalError("error: weekday in reminder is nil") }
            components.weekday = weekday!
        case .monthly:
            guard day != nil else { fatalError("error: day in reminder is nil") }
            components.day = day!
        }
        
        return components
    }
}

extension Reminder {
    static let dailyReminder   = Reminder(repeatPeriod: .daily,
                                          hour: 9, minute: 17)
    static let weeklyReminder  = Reminder(repeatPeriod: .weekly,
                                          hour: 9, minute: 17,
                                          weekday: 4)
    static let monthlyReminder = Reminder(repeatPeriod: .monthly,
                                          day: 3,
                                          hour: 9, minute: 17)
}

