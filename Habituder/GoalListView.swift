//
//  GoalListView.swift
//  Habituder
//
//  Created by Igor Malyarov on 01.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import SwiftPI

struct GoalListView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var notificationSettings: NotificationSettings
    
    @State private var showNotifications = false
    @State private var showEditor = false
    @State private var selected: Int = 0
    
    private func goalRow(index: Int, goal: Goal) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(goal.name)
                    .foregroundColor(.systemOrange)
                
                Spacer()
                
                Text(goal.reminder.description)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text(goal.note)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                
                Spacer()
                
                Text(goal.reminder.nextDate.dateAndTimetoString())
                    .foregroundColor(goal.reminder.nextDate > Date() ? .tertiary : .systemRed)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.selected = index
            self.showEditor = true
        }
    }
    
    var body: some View {
        
        List {
            ForEach(store.goals.enumeratedArray(), id: \.element.id) { index, goal in
                
                //  GoalListRow(goal: goal, selected: self.$selected, showEditor: self.$showEditor)
                self.goalRow(index: index, goal: goal)
                    .contextMenu {
                        Button(action: {
                            self.remove(goal: goal)
                        }) {
                            Image(systemName: "trash.circle")
                            Text("Delete Goal")
                        }
                }
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }
        .sheet(isPresented: $showEditor) {
            GoalEditor(goal: self.store.goals[self.selected], index: self.selected)
                .environmentObject(self.store)
                .environmentObject(self.notificationSettings)
        }
        .onAppear {
            DispatchQueue.main.async {//After(deadline: .now() + 1) {
                if self.store.haveIssues {
                    print("have issues")
                } else {
                    print("no issues")
                }
            }
        }
        .navigationBarTitle("Goals", displayMode: .automatic)
        .navigationBarItems(
            leading: EditButton(),
            trailing: HStack {
                TrailingButtonSFSymbol("textformat.size") {
                    self.sortByNextDate()
                }
                TrailingButtonSFSymbol(store.haveIssues ? "bell.fill" : "bell.circle") {
                    self.showNotifications = true
                }
                .foregroundColor(store.haveIssues ? .systemRed : .accentColor)
                .sheet(isPresented: $showNotifications) {
                    //                Text("test")
                    AllNotificationsView()
                        .environmentObject(self.store)
                        .environmentObject(self.notificationSettings)
                }
                TrailingButtonSFSymbol("text.badge.plus") {
                    self.appendTestingStore()
                }
                TrailingButtonSFSymbol("plus") {
                    self.createNew()
                }
            }
        )
    }
    
    func sortByNextDate() {
        store.sortByNextDate()
    }
    
    func appendTestingStore() {
        store.appendTestingStore()
    }
    
    func createNew() {
        store.createNewGoal()
        selected = 0
        showEditor = true
    }
    
    private func remove(goal: Goal) {
        store.remove(goal: goal)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        store.move(from: source, to: destination)
    }
    
    private func delete(at offsets: IndexSet) {
        store.delete(at: offsets)
    }
    
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoalListView()
        }
        .environmentObject(Store())
        .environment(\.colorScheme, .dark)
    }
}
