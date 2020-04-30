//
//  PartOfDay.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 21.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

enum PartOfDay: String, Codable, CaseIterable {
    case morning, afternoon, evening
    
    var id: String { rawValue }
        
    var time: DateComponents {
        switch self {
        case .morning:
            return DateComponents(hour: 9, minute: 05)
            case .afternoon:
                return DateComponents(hour: 13, minute: 15)
            case .evening:
                return DateComponents(hour: 19, minute: 30)
        }
        
    }
}
