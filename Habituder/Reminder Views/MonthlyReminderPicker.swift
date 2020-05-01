//
//  MonthlyReminderPicker.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 28.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct MonthlyReminderPickerTester: View {
    @State private var reminder: Reminder = .monthlyReminder
    
    var body: some View {
        VStack {
            MonthlyReminderPicker(reminder: $reminder)
        }
    }
}

struct MonthlyReminderPicker: View {
    @Binding var reminder: Reminder
    
    var body: some View {
        
        let day: Binding<Int> = Binding(
            get: {
                return self.reminder.dateComponents.day ?? 1
        },
            set: {
                print("FIX THIS!!!")
                let calendar = Calendar.current
                self.reminder.pickerDate = calendar.date(byAdding: .day,
                                                         value: $0,
                                                         to: self.reminder.pickerDate) ?? Date()
//                self.reminder.dateComponents.day = $0
        }
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
            
            Form {
                DatePicker("At a time", selection: $reminder.pickerDate, displayedComponents: .hourAndMinute)
            }
        }
    }
    
    private func monthViewSize(maxWidth: CGFloat, maxHeight: CGFloat) -> (width: CGFloat, height: CGFloat) {
        let cellSize = min(maxWidth / 7, maxHeight / 5)
        return (width: cellSize * 7, height: cellSize * 5)
    }
}

struct MonthView: View {
    @Binding var selected: Int
    var maxWidth: CGFloat
    var maxHeight: CGFloat
    
    private func cell(row: Int, col: Int, cellSize: CGFloat) -> some View {
        let day = row * 7 + col
        
        let calendar = Calendar.autoupdatingCurrent
        let timeZone = TimeZone.autoupdatingCurrent
        let today = calendar.dateComponents(in: timeZone, from:Date()).day!
        
        return Text(day <= 31 ? "\(day)" : " ")
            .frame(width: cellSize, height: cellSize)
            .foregroundColor(self.selected == day
                ? Color.orange
                : day == today
                ? Color.primary
                : Color.secondary)
            .font(cellSize < 36 ? .caption : .body)
            .background(self.selected == day ? Color.tertiarySystemBackground : Color.clear)
            .border(Color.systemGray5, width: 0.5)
            .contentShape(Rectangle())
            .onTapGesture {
                //  MARK: ADD HAPTIC
                //
                withAnimation {
                    //    if self.selected == nil {
                    //        self.selected = day
                    //        return
                    //    }
                    //
                    //    if self.selected == day {
                    //        self.selected = nil
                    //        return
                    //    }
                    
                    self.selected = day
                }
        }
    }
    
    var body: some View {
        let cellSize = min(maxWidth / 7, maxHeight / 5)
        //        print("maxWidth: \(maxWidth) | maxHeight: \(maxHeight) | cellSize: \(cellSize)")
        
        return VStack(spacing: 0) {
            ForEach(0...4, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { col in
                        self.cell(row: row, col: col, cellSize: cellSize)
                    }
                }
            }
        }
        .frame(width: cellSize * 7, height: cellSize * 5)
    }
}

struct MonthlyReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            //            VStack {
            MonthlyReminderPickerTester()
            //                    .border(Color.blue)
            //            }
        }
        //        .environment(\.colorScheme, .dark)
    }
}
