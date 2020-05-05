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
    @EnvironmentObject var store: Store
    @EnvironmentObject var notificationSettings: NotificationSettings
    
    //  ------------------------------------------------------
    //  MARK: CHANGE LOGIC AND DELETE GoalNotifications
    //
    @ObservedObject var goalNotifications: GoalNotifications
    //
    //  ------------------------------------------------------
    
    var index: Int
    
    @State private var name: String
    @State private var note: String
    @State private var reminder: Reminder
    
    init(goal: Goal, index: Int) {
        self._name = State(initialValue: goal.name)
        self._note = State(initialValue: goal.note)
        self._reminder = State(initialValue: goal.reminder)
        self.index = index
        self.goalNotifications = GoalNotifications(identifier: goal.identifier)
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
        
        func smallButtonLabel(title: String, fillColor: Color, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Text(title)
                    .foregroundColor(.accentColor)
                    .fontWeight(.semibold)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(fillColor)
                )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(Color.tertiarySystemFill)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        
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
                    
                    HStack {
                        
                        ForEach(PartOfDay.allCases, id: \.self) { part in
                            Group {
                                smallButtonLabel(title: part.id, fillColor: self.reminder.pickerTime == part.time ? Color.quaternarySystemFill : .clear) {
                                    
                                    //  MARK: ADD LIGHT HAPTIC
                                    //
                                    
                                    self.reminder.pickerTime = part.time
                                }
                                
                                Spacer()
                            }
                        }
                        
                        smallButtonLabel(title: "Now*", fillColor: .clear) {
                            
                            //  MARK: ADD LIGHT HAPTIC
                            //
                            withAnimation {
                                let date = Date()
                                let calendar = Calendar.current
                                let hour = calendar.component(.hour, from: date)
                                let minute = calendar.component(.minute, from: date) + 1
                                let components = DateComponents(hour: hour, minute: minute)
                                self.reminder.pickerTime = calendar.date(from: components)!
                            }
                        }
                    }
                    .font(.footnote)
                }
                
                Section(header: Text("Pending Notifications".uppercased())
                ) {
                    HStack {
                        Text(goalNotifications.pendingNotifications)
                            .foregroundColor(goalNotifications.color)
                            .font(goalNotifications.font)
                        
                        if goalNotifications.isEmpty != nil {
                            if goalNotifications.isEmpty! {
                                Spacer()
                                
                                Button("FIX") {
                                    self.fixNotification()
                                }
                            }
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
        store.updateGoalWithIndex(index, name: name, note: note, reminder: reminder)
    }
    
    private func fixNotification() {
        self.update()
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
            .environmentObject(Store())
            .environmentObject(NotificationSettings())
            .environment(\.colorScheme, .dark)
    }
}
