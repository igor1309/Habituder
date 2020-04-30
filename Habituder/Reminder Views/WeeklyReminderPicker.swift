//
//  WeeklyReminderPicker.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 29.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct WeeklyReminderPickerTester: View {
    @State private var reminder: Reminder = .weeklyReminder
    
    var body: some View {
        VStack {
            WeeklyReminderPicker(reminder: $reminder)
        }
    }
}

struct WeeklyReminderPicker: View {
    @Binding var reminder: Reminder
    
    var body: some View {
        let selectedDate: Binding<Date> = Binding(
            get: {
                self.reminder.date
        },
            set: {
                let calendar = Calendar.current
                var components = calendar.dateComponents(self.reminder.repeatPeriod.pickerDateComponents, from: $0)
                components.weekday = self.reminder.dateComponents.weekday ?? 0
                self.reminder.dateComponents = components
        }
        )
        
        let weekday: Binding<Int> = Binding(
            get: {
                return self.reminder.dateComponents.weekday ?? 0
        },
            set: {
                self.reminder.dateComponents.weekday = $0
                
        }
        )
        
        return Group {
            Text(reminder.description)
            
            WeekdayPicker(selected: weekday, shortSymbols: false)
//                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
            
            DatePicker("At a time", selection: selectedDate, displayedComponents: .hourAndMinute)
        }
    }
}

struct WeeklyReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyReminderPickerTester()
    }
}
