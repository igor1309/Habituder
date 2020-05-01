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
        DatePicker("Daily at", selection: $reminder.pickerDate, displayedComponents: .hourAndMinute)
    }
}

struct DailyReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        DailyReminderPickerTester()
    }
}
