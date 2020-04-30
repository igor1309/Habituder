//
//  Periodic.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 28.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

enum Periodic {
    case daily(hour: Int, minute: Int)
    case weekly(weekday: Int, hour: Int, minute: Int)
    case monthly(day: Int, hour: Int, minute: Int)
    
    var dateComponents: DateComponents {
        switch self {
        case let .daily(hour, minute):
            return DateComponents(hour: hour, minute: minute)
        case let .weekly(weekday, hour, minute):
            return DateComponents(hour: hour, minute: minute, weekday: weekday)
        case let .monthly(day, hour, minute):
            return DateComponents(day: day, hour: hour, minute: minute)
        }
    }
    
    var id: String {
        switch self {
        case .daily(_, _):
            return "Daily"
        case .weekly(_, _, _):
            return "Weekly"
        case .monthly(_, _, _):
            return "Monthly"
        }
    }
}
