//
//  GoalListView.swift
//  GoalGetter
//
//  Created by Igor Malyarov on 28.04.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import SwiftPI

struct GoalListView: View {
    @EnvironmentObject var goalStore: GoalStore
    
    @State private var showDetail = false
    @State private var index: Int = 0
    
    func row(goal: Goal) -> some View {
        var index: Int {
            goalStore.goals.firstIndex(of: goal)!
        }
        
        return VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(goal.name)
                    .foregroundColor(.systemOrange)
                
                Spacer()
                
                Text(goal.reminder.description)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Text(goal.note)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            //  MARK: ADD HAPTIC
            //
            
            self.index = index
            self.showDetail = true
        }
    }
    
    var body: some View {
        List {
            PermisionsNoteView()
            
            ForEach(goalStore.goals) { goal in
                self.row(goal: goal)
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }
        .sheet(isPresented: self.$showDetail) {
            GoalDetail(goal: self.goalStore.goals[self.index], goalIndex: self.index)
                .environmentObject(self.goalStore)
        }
        .navigationBarTitle("Goals", displayMode: .automatic)
        .navigationBarItems(
            leading: EditButton(),
            trailing: HStack {
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
    }
    
    func move(from source: IndexSet, to destination: Int) {
        goalStore.move(from: source, to: destination)
    }
    
    func delete(at offsets: IndexSet) {
        goalStore.delete(at: offsets)
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            GoalListView()
        }
        .environmentObject(GoalStore())
        .environment(\.colorScheme, .dark)
    }
}
