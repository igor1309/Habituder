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
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
//            PartOfDaySettingsView()
            GoalListView()
        }
        .onAppear { self.store.load() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
            .environment(\.colorScheme, .dark)
    }
}
