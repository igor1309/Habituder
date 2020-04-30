//
//  ContentView.swift
//  Habituder
//
//  Created by Igor Malyarov on 01.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI
import SwiftPI

struct ContentView: View {
    @EnvironmentObject var goalStore: GoalStore
    
    var body: some View {
        NavigationView {
            GoalListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GoalStore())
            .environmentObject(NotificationStore())
            .environment(\.colorScheme, .dark)
    }
}
