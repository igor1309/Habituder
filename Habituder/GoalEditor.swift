//
//  GoalEditor.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import Combine
import UserNotifications

struct GoalEditor: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var goalStore: GoalStore
    
    @ObservedObject var goalNotifications: GoalNotifications
    
    var index: Int
    
    @State private var name: String
    @State private var note: String
    @State private var reminder: Reminder
    
    init(goal: Goal, index: Int) {
        self._name = State(initialValue: goal.name)
        self._note = State(initialValue: goal.note)
        self._reminder = State(initialValue: goal.reminder)
        self.index = index
        self.goalNotifications = GoalNotifications(identifier: goal.id.uuidString)
    }
    
    @State private var partOfDay: PartOfDay = .morning
    
    var body: some View {
        
        func picker() -> some View {
            switch reminder.repeatPeriod {
            case.daily:
                return AnyView(EmptyView())
            case .weekly:
                return AnyView(
                    WeeklyReminderPicker(reminder: $reminder)
                )
            case .monthly:
                return AnyView(
                    NavigationLink(destination: MonthlyReminderPicker(reminder: $reminder)
                    ) {
                        Text(reminder.shortDescription)
                    }
                )
            }
        }
        
        let dayPart: Binding<PartOfDay> = Binding(
            get: { self.partOfDay },
            set: {
                self.partOfDay = $0
                self.reminder.pickerTime = self.partOfDay.time
        })
        
        return NavigationView {
            Form {
                Section(header: Text("Details".uppercased())
                ) {
                    TextField("Goal Name", text: $name)
                        .foregroundColor(.systemOrange)
                    
                    TextField("Goal Note", text: $note)
                }
                
                Section(header: Text("Remind Me".uppercased()),
                        footer: Text("\(reminder.repeatPeriod.id): \(reminder.toString())")
                            .foregroundColor(.tertiary)
                            .font(.caption)
                ) {
                    Text("\(reminder.description)")
                        .foregroundColor(.systemOrange)
                    
                    RepeatPeriodPicker(period: $reminder.repeatPeriod)
                    
                    picker()
                    
                    DatePicker(reminder.repeatPeriod == .daily ? "Daily at" : "At a time",
                               selection: $reminder.pickerTime,
                               displayedComponents: .hourAndMinute)
                    
                    VStack(alignment: .leading) {
                        Text("Quick Time")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                        
                        Picker("Part of the Day", selection: dayPart) {
                            ForEach(PartOfDay.allCases, id: \.self) { part in
                                Text(part.id).tag(part)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Section(header: Text("Pending Notifications".uppercased())) {
                    Text(goalNotifications.pendingNotifications)
                        .foregroundColor(goalNotifications.isEmpty ? .systemRed : .secondary)
                        .font(goalNotifications.isEmpty ? .body : .caption)
                    
                    if goalNotifications.isEmpty {
                        Button("TBD: FIX: Schedule Notification") {
                            self.scheduleNotification()
                        }
                    }
                    
                    NotificationSettingsView()
                }
            }
            .navigationBarTitle(name)
            .navigationBarItems(trailing: Button("Done") {
                self.update()
                self.presentation.wrappedValue.dismiss()
            })
        }
    }
    
    private func update() {
        goalStore.update(goalIndex: index, name: name, note: note, reminder: reminder)
    }
    
    private func scheduleNotification() {
        //  MARK :FINISH THIS
        //
        
    }
}

struct GoalEditorTester: View {
    let index = 1
    var body: some View {
        GoalEditor(goal: Goal.testingGoals()[index], index: index)
    }
}

struct GoalEditor_Previews: PreviewProvider {
    static var previews: some View {
        GoalEditorTester()
            .environment(\.colorScheme, .dark)
    }
}
