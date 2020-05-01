//
//  DailyReminderPicker.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 29.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct DailyReminderPickerTester: View {
    @State private var reminder: Reminder = .morningDailyReminder
//    @State private var draft: Goal = Goal(name: "Test Goal", note: "Text Goal Note", reminder: Reminder.weeklyReminder)
    
    var body: some View {
        Form {
            DailyReminderPicker(reminder: $reminder)
        }
    }
}

struct DailyReminderPicker: View {
    @Binding var reminder: Reminder
    
    var body: some View {
        let selectedDate: Binding<Date> = Binding(
            get: {
                self.reminder.date
        },
            set: {
                let calendar = Calendar.current
                let components = calendar.dateComponents(self.reminder.repeatPeriod.pickerDateComponents, from: $0)
                self.reminder.dateComponents = components
        }
        )
        
//        return DatePicker("Daily at", selection: selectedDate, displayedComponents: .hourAndMinute)
        return DailyDatePicker(date:selectedDate)
    }
}

struct DailyDatePicker: View {
    @Binding var date: Date
    
    var body: some View {
        DatePicker("Daily at", selection: $date, displayedComponents: .hourAndMinute)
    }
}

struct DailyReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        DailyReminderPickerTester()
    }
}
