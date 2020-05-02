//
//  GoalDetailView.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import SwiftPI

struct RepeatPeriodPicker: View {
    @Binding var period: RepeatPeriod
    
    var body: some View {
        Picker("Frequency", selection: $period) {
            ForEach(RepeatPeriod.allCases, id: \.self) { period in
                Text(period.id).tag(period)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct GoalDetailView: View {
    @EnvironmentObject var goalStore: GoalStore
    
    var index: Int
    @State private var draft: Goal
    
    @State private var test: Goal = Goal(name: "test", note: "testtest", reminder: Reminder(repeatPeriod: .daily, hour: 8, minute: 35))
    @State private var showTesting = true
    
    init(goal: Goal, index: Int) {
        self._draft = State(initialValue: goal)
        self.index = index
    }
    
    var body: some View {
        let periodDraftBinding: Binding<RepeatPeriod> = Binding(
            get: { self.draft.reminder.repeatPeriod },
            set: {
                print("period set: \($0)")
                self.draft.reminder.repeatPeriod = $0 }
        )
        
        let reminder: Binding<Reminder> = Binding(
            get: { self.goalStore.goals[self.index].reminder },
            set: {
                print("period set: \($0)")
                self.goalStore.goals[self.index].reminder = $0 }
        )
        
        let period: Binding<RepeatPeriod> = Binding(
            get: { self.goalStore.goals[self.index].reminder.repeatPeriod },
            set: {
                print("period set: \($0)")
                self.goalStore.goals[self.index].reminder.repeatPeriod = $0 }
        )
        
        func picker(/*for period: RepeatPeriod*/) -> some View {
            switch period.wrappedValue {
            case.daily:
                return AnyView(EmptyView())
            case .weekly:
                return AnyView(
                    WeeklyReminderPicker(reminder: reminder) //self.$goalStore.goals[self.index].reminder)
                )
            case .monthly:
                return AnyView(
                    NavigationLink(destination: MonthlyReminderPicker(reminder: reminder) //self.$goalStore.goals[self.index].reminder)
                    ) {
                        Text(self.goalStore.goals[self.index].reminder.description)
                    }
                )
            }
        }
        
        return NavigationView {
            Form {
                Section(header: Text("Details".uppercased())
                ) {
                    TextField("Goal Name", text: $draft.name)
                    TextField("Goal Note", text: $draft.note)
                }
                
                Section(header: Text("Reminder".uppercased())
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(reminder.wrappedValue.description)")
                            .foregroundColor(.systemOrange)
                        Text("\(reminder.wrappedValue.repeatPeriod.id): \(reminder.wrappedValue.toString())")
                            .foregroundColor(.tertiary)
                            .font(.footnote)
                    }
                    
                    RepeatPeriodPicker(period: period)
                    
                    picker()
                    
                    DatePicker(period.wrappedValue == .daily ? "Daily at" : "At a time",
                               selection: reminder.pickerTime,
                               displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Pending Notifications".uppercased())
                ) {
                    Text("sdfsf")
                }
                
                //  MARK: - TESTING
                //
                if showTesting {
                    Section(
                        header: Text("Draft Testing".uppercased())
                            .foregroundColor(.systemOrange),
                        footer: Text("Check whether picker binding to draft is working not just once. Also check print in debug.\nCould you use DRAFT or continue with binding to array elements via index?")
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("custom binding periodDraftBinding")
                                .font(.subheadline)
                            RepeatPeriodPicker(period: periodDraftBinding)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("@State: $draft.reminder.repeatPeriod")
                                .font(.subheadline)
                            RepeatPeriodPicker(period: $draft.reminder.repeatPeriod)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("@State: $test.reminder.repeatPeriod")
                                .font(.subheadline)
                            RepeatPeriodPicker(period: $test.reminder.repeatPeriod)
                        }
                    }
                }
            }
            .navigationBarTitle(draft.name)
            .navigationBarItems(leading: LeadingButtonSFSymbol(showTesting ? "questionmark.circle.fill" : "questionmark.circle") {
                self.showTesting.toggle()
            }
            .foregroundColor(showTesting ? .systemOrange : .accentColor)
            )
        }
    }
    
    private func update(goal: Goal, with newValue: Goal) {
        goalStore.update(goal: goal, with: newValue)
    }
}

struct GoalDetailView_Previews: PreviewProvider {
    static var index = 1
    static var previews: some View {
        GoalDetailView(goal: Goal.testingGoals()[index], index: index)
            .environmentObject(GoalStore())
            .environment(\.colorScheme, .dark)
    }
}
