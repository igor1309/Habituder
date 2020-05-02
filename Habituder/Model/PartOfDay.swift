//
//  PartOfDay.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 21.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

enum PartOfDay: String, Codable, CaseIterable, Hashable {
    case morning, afternoon, evening
    
    var id: String { rawValue.capitalized }
    
    var time: Date {
        let calendar = Calendar.autoupdatingCurrent
        var dateComponents = DateComponents()
        
        switch self {
        case .morning:
            dateComponents = DateComponents(hour: 9, minute: 05)
        case .afternoon:
            dateComponents = DateComponents(hour: 13, minute: 15)
        case .evening:
            dateComponents = DateComponents(hour: 19, minute: 30)
        }
        
        return calendar.date(from: dateComponents)!
    }
    
    var timeStr: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: time)
    }
}
