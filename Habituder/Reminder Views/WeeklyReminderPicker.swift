//
//  WeeklyReminderPicker.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct WeeklyReminderPickerTester: View {
    @State private var remimder: Reminder = .weeklyReminder
    
    var body: some View {
        NavigationView {
            Form {
                WeeklyReminderPicker(reminder: $remimder)
            }
        }
    }
}

struct WeeklyReminderPicker: View {
    @Binding var reminder: Reminder
    
    var body: some View {
        
        let weekday: Binding<Int> = Binding(
            get: { self.reminder.weekday ?? -1 },
            set: { self.reminder.weekday = $0 }
        )
        
        return Group {
            Text("Every \(Calendar.current.weekdaySymbols[weekday.wrappedValue])")            
            WeekdayPicker(weekday: weekday, shortSymbols: true)
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct WeeklyReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyReminderPickerTester()
            .environment(\.colorScheme, .dark)
    }
}
