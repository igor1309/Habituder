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
        
        let weekday: Binding<Int> = Binding(
            get: {
                print("weekday: Binding get: \(self.reminder.dateComponents.weekday)")
                return (self.reminder.dateComponents.weekday ?? 1)
        },
            set: {
                print("FIX THIS!!!")
                print("weekday: Binding set: weekday: \($0)")
                let calendar = Calendar.current
                self.reminder.pickerDate = calendar.date(byAdding: .weekday,
                                                         value: $0,
                                                         to: self.reminder.pickerDate) ?? Date()
                //                self.reminder.dateComponents.weekday = $0
                
        }
        )
        
        return Group {
            Text(reminder.description)
            
            WeekdayPicker(selected: weekday, shortSymbols: false)
//                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
            
            DatePicker("At a time", selection: $reminder.pickerDate, displayedComponents: .hourAndMinute)
        }
    }
}

struct WeeklyReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyReminderPickerTester()
    }
}
