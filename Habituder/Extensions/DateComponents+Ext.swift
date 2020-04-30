//
//  DateComponents+Ext.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 28.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

extension DateComponents {
    /// string represetnation of DateComponents
    func toString() -> String {
        var str = [String]()
        
        if self.era != nil { str.append("era: \(self.era!)") }
        if self.year != nil { str.append("year: \(self.year!)") }
        if self.month != nil { str.append("month: \(self.month!)") }
        if self.day != nil { str.append("day: \(self.day!)") }
        if self.hour != nil { str.append("hour: \(self.hour!)") }
        if self.minute != nil { str.append("minute: \(self.minute!)") }
        if self.second != nil { str.append("second: \(self.second!)") }
        if self.nanosecond != nil { str.append("nanosecond: \(self.nanosecond!)") }
        if self.weekday != nil { str.append("weekday: \(self.weekday!)") }
        if self.weekdayOrdinal != nil { str.append("weekdayOrdinal: \(self.weekdayOrdinal!)") }
        if self.quarter != nil { str.append("quarter: \(self.quarter!)") }
        if self.weekOfMonth != nil { str.append("weekOfMonth: \(self.weekOfMonth!)") }
        if self.weekOfYear != nil { str.append("weekOfYear: \(self.weekOfYear!)") }
        if self.yearForWeekOfYear != nil { str.append("yearForWeekOfYear: \(self.yearForWeekOfYear!)") }
        
        return str.joined(separator: ", ")
    }
}
