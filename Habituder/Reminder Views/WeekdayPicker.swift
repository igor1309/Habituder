//
//  WeekdayPicker.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct WeekdayPicker: View {
    @Binding var weekday: Int
    
    var shortSymbols: Bool
    
    var weekdaySymbols: [String] {
        if shortSymbols {
            return Calendar.current.shortWeekdaySymbols
        } else {
            return Calendar.current.weekdaySymbols
        }
    }
    
    var body: some View {
        Picker(selection: $weekday, label: Text("Weekday")) {
            ForEach(weekdaySymbols.indices, id: \.self) { dayIndex in
                Text(self.weekdaySymbols[dayIndex]).tag(dayIndex)
            }
        }
    }
}

struct WeekdayPickerTester: View {
    @State private var weekday: Int = 1
    
    var body: some View {
        NavigationView {
            Form {
                Text(Calendar.current.weekdaySymbols[weekday])
                Text("weekday: \(weekday)")
                WeekdayPicker(weekday: $weekday, shortSymbols: true)
                    .pickerStyle(SegmentedPickerStyle())
                
                WeekdayPicker(weekday: $weekday, shortSymbols: false)
            }
        }
    }
}

struct WeekdayPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeekdayPickerTester()
            .environment(\.colorScheme, .dark)
    }
}
