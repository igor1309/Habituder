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
}
