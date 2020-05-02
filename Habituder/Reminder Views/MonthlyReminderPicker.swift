//
//  MonthlyReminderPicker.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct MonthlyReminderPicker: View {
    @Binding var reminder: Reminder
    
    var body: some View {
        
        let day: Binding<Int> = Binding(
            get: { self.reminder.day ?? -1 },
            set: { self.reminder.day = $0 }
        )
        
        return VStack(alignment: .leading) {
            Group {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Each")
                        .padding(.top)
                    
                    Text(reminder.description)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.leading)
                
                GeometryReader { geo in
                    MonthView(selected: day, maxWidth: geo.size.width, maxHeight: geo.size.height)
                        .frame(width: self.monthViewSize(maxWidth: geo.size.width, maxHeight: geo.size.height).width,
                               height: self.monthViewSize(maxWidth: geo.size.width, maxHeight: geo.size.height).height)
                }
            }
        }
    }
    
    private func monthViewSize(maxWidth: CGFloat, maxHeight: CGFloat) -> (width: CGFloat, height: CGFloat) {
        let cellSize = min(maxWidth / 7, maxHeight / 5)
        return (width: cellSize * 7, height: cellSize * 5)
    }
}

struct MonthlyReminderPickerTester: View {
    @State private var remimder: Reminder = .monthlyReminder
    
    var body: some View {
        NavigationView {
            MonthlyReminderPicker(reminder: $remimder)
        }
    }
}

struct MonthlyReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyReminderPickerTester()
            .environment(\.colorScheme, .dark)
    }
}
