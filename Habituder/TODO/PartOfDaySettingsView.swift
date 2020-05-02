//
//  PartOfDaySettingsView.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct PartOfDaySettingsView: View {
    @State private var morning = Date()
    @State private var afternoon = Date()
    @State private var evening = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Morning".uppercased())
            ) {
                DatePicker("Default Time for Morning", selection: .constant(Date()), displayedComponents: .hourAndMinute)
            }
            
            Section(header: Text("Afternoon".uppercased())
            ) {
                DatePicker("Default Time for Afternoon", selection: .constant(Date()), displayedComponents: .hourAndMinute)
            }
            
            Section(header: Text("Evening".uppercased())
            ) {
                DatePicker("Default Time for Evening", selection: .constant(Date()), displayedComponents: .hourAndMinute)
            }
        }
        .navigationBarTitle("Time for Part of the Day", displayMode: .inline)
    }
}

struct PartOfDaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PartOfDaySettingsView()
        }
        .environment(\.colorScheme, .dark)
    }
}
