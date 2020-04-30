//
//  GoalDetail.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 21.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import SwiftPI
import UserNotifications

struct GoalDetail: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var goalStore: GoalStore
    
    var goalIndex: Int
    @State private var draft: Goal
    
    init(goal: Goal, goalIndex: Int) {
        self.goalIndex = goalIndex
        self._draft = State(initialValue: goal)
    }
    
    @State private var pendingNotifications = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details".uppercased())) {
                    TextField("Goal Name", text: $draft.name)
                    TextField("Goal Note", text: $draft.note)
                }
                
                Section(header: Text("Reminder".uppercased())) {
                    ReminderView(reminder: $draft.reminder)
                }
                
                Section(header: Text("Pending Notifications".uppercased())) {
                    
                    Text("\(pendingNotifications.isEmpty ? "none" : pendingNotifications)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    if pendingNotifications.isEmpty {
                        Button("TBD: Schedule Notification") {
                            self.scheduleNotification()
                        }
                    }
                    
                    PermisionsNoteView()
                }
                
                /// Удаление Goal в этом вью перемешивает индексы в списке GoalListView и всё ломается. Поэтому удаление остается только через свайп в списке (и нет кнопки Delete Goal в этом вью).
            }
            .onAppear {
                self.checkPendingNotifications()
            }
            .navigationBarTitle(draft.name)
            .navigationBarItems(
                trailing: Button("Save") {
                    self.goalStore
                        .updateGoal(at: self.goalIndex, with: self.draft)
                    self.presentation.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func scheduleNotification() {
        //  MARK :FINISH THIS
        //
        
    }
    
    //  MARK: create publisher? move to Goal
    private func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let id: String = self.goalStore.goals[self.goalIndex].id.uuidString
            
            DispatchQueue.main.async {
                self.pendingNotifications =
                    ListFormatter.localizedString(byJoining: requests
                        .filter { $0.identifier == id }
                        .map { $0.trigger.debugDescription })
                if self.pendingNotifications.isEmpty {
                    //  MARK: check notification permissions - they could be not allowed
                    //
                }
            }
        }
    }
}

struct GoalDetail_Previews: PreviewProvider {
    static let index = 0
    static var previews: some View {
        GoalDetail(goal: GoalStore.testingStore()[index], goalIndex: index)
            .environmentObject(GoalStore())
            .environment(\.colorScheme, .dark)
    }
}
