//
//  GoalEditor.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct GoalEditor: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var goalStore: GoalStore
    
    var index: Int
    
    @State private var name: String
    @State private var note: String
    @State private var reminder: Reminder
    
    init(goal: Goal, index: Int) {
        self._name = State(initialValue: goal.name)
        self._note = State(initialValue: goal.note)
        self._reminder = State(initialValue: goal.reminder)
        self.index = index
    }
    
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
                        Text(reminder.description)
                    }
                )
            }
        }
        
        return NavigationView {
            Form {
                Section(header: Text("Details".uppercased())
                ) {
                    TextField("Goal Name", text: $name)
                    TextField("Goal Note", text: $note)
                }
                
                Section(header: Text("Reminder".uppercased()),
                        footer: VStack(alignment: .leading, spacing: 4) {
                            Text("\(reminder.description)")
                                .foregroundColor(.systemOrange)
                            Text("\(reminder.repeatPeriod.id): \(reminder.toString())")
                                .foregroundColor(.tertiary)
                        }
                        .font(.caption)
                ) {
                    RepeatPeriodPicker(period: $reminder.repeatPeriod)
                    
                    picker()
                    
                    DatePicker(reminder.repeatPeriod == .daily ? "Daily at" : "At a time",
                               selection: $reminder.pickerTime,
                               displayedComponents: .hourAndMinute)
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
