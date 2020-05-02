//
//  RepeatPeriod.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

enum RepeatPeriod: String, CaseIterable, Codable {
    case daily, weekly, monthly
    
    var id: String { rawValue.capitalized }
    
    /// какие компоненты используются в пикере — не путать с компонентами для настройки уведомления
    /// день недели для weekly и день для monthly определяются не в пикере
    var pickerDateComponents: Set<Calendar.Component> {
        switch self {
        case .daily:
            return [.hour, .minute]
        case .weekly:
            return [.hour, .minute]
        case .monthly:
            return [.day, .hour, .minute]
        }
    }
}
