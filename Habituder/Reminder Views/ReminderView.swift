//
//  ReminderView.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 29.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct ReminderViewTesting: View {
    @State private var monthlyReminder: Reminder = .weeklyReminder
//    @State private var draft: Goal = Goal(name: "Test Goal", note: "Text Goal Note", reminder: Reminder.weeklyReminder)
    
    var body: some View {
        NavigationView {
            Form {
                ReminderView(reminder: $monthlyReminder)
                    .navigationBarTitle(Text("Repeat"), displayMode: .inline)
            }
        }
    }
}

struct ReminderView: View {
    @Binding var reminder: Reminder
//    @Binding var goal: Goal
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(reminder.description)")
                    .foregroundColor(.systemOrange)
                Text("\(reminder.repeatPeriod.id): \(reminder.dateComponents.toString())")
                    .foregroundColor(.secondary)
            }
            .font(.footnote)
            
            Picker(selection: $reminder.repeatPeriod, label: Text("Frequency")) {
                ForEach(RepeatPeriod.allCases, id: \.self) { period in
                    Text(period.id).tag(period)
                }
            }
            
            if reminder.repeatPeriod == .daily {
                DailyReminderPicker(reminder: $reminder)
            }
            
            if reminder.repeatPeriod == .weekly {
                WeeklyReminderPicker(reminder: $reminder)
            }
            
            if reminder.repeatPeriod == .monthly {
                NavigationLink(destination: MonthlyReminderPicker(reminder: $reminder)) {
                    Text(reminder.description)
                }
            }
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderViewTesting()
    }
}
