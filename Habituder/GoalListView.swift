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
    @EnvironmentObject var goalStore: GoalStore
    
    @State private var showNotifications = false
    @State private var showEditor = false
    @State private var selected: Int = 0
    
    private func goalRow(goal: Goal) -> some View {
        let index = goalStore.goals.firstIndex(of: goal)!
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(goal.name)
                    .foregroundColor(.systemOrange)
                
                Spacer()
                
                Text(goal.reminder.description)
                    .foregroundColor(.tertiary)
                    .font(.caption)
            }
            
            Text(goal.note)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.selected = index
            self.showEditor = true
        }
    }
    
    var body: some View {
        List {
            ForEach(goalStore.goals) { goal in
                
                //  GoalListRow(goal: goal, selected: self.$selected, showEditor: self.$showEditor)
                self.goalRow(goal: goal)
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
            GoalEditor(goal: self.goalStore.goals[self.selected], index: self.selected)
                .environmentObject(self.goalStore)
        }
        .onAppear {
            DispatchQueue.main.async {//After(deadline: .now() + 1) {
                if self.goalStore.anyIssues {
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
                TrailingButtonSFSymbol(goalStore.anyIssues ? "bell.fill" : "bell.circle") {
                    self.showNotifications = true
                }
                .foregroundColor(goalStore.anyIssues ? .systemRed : .accentColor)
                .sheet(isPresented: $showNotifications) {
//                Text("test")
                        AllNotificationsView()
                        .environmentObject(self.goalStore)
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
    
    func appendTestingStore() {
        goalStore.appendTestingStore()
    }
    
    func createNew() {
        goalStore.createNew()
        selected = 0
        showEditor = true
    }
    
    private func remove(goal: Goal) {
        goalStore.remove(goal: goal)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        goalStore.move(from: source, to: destination)
    }
    
    private func delete(at offsets: IndexSet) {
        goalStore.delete(at: offsets)
    }
    
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoalListView()
        }
        .environmentObject(GoalStore())
        .environment(\.colorScheme, .dark)
    }
}
