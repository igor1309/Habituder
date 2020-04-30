//
//  WeekdayPicker.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 28.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct WeekdayPicker: View {
    @Binding var selected: Int
    var shortSymbols: Bool
    
    var weekdaySymbols: [String] {
        if shortSymbols {
            return Calendar.current.shortWeekdaySymbols
        } else {
            return Calendar.current.weekdaySymbols
        }
    }
    
    var body: some View {
        Picker(selection: $selected, label: Text("Weekday")) {
            ForEach(weekdaySymbols.indices, id: \.self) { dayIndex in
//                HStack {
                    Text(self.weekdaySymbols[dayIndex]).tag(dayIndex)
//                    Spacer()
                    
//                    if self.selected == dayIndex {
//                        Image(systemName: "checkmark")
//                            .foregroundColor(.systemBlue)
//                    }
//                }
//                .contentShape(Rectangle())
                //                .onTapGesture {
                //                    //  MARK: ADD LIGHT HAPTIC FEEDBACK
                //                    //
                //                    if self.selectedDay == day {
                //                        self.selectedDay = nil
                //                    } else {
                //                        self.selectedDay = day
                //                    }
                //                }
            }
        }
    }
}

struct WeekdayPickerTester: View {
    @State private var day: Int = 0
    
    var body: some View {
        WeekdayPicker(selected: $day, shortSymbols: false)
    }
}

struct WeekdayPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        WeekdayPickerTester()
    }
}
