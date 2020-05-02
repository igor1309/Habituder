//
//  RepeatPeriodPicker.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

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

struct RepeatPeriodPicker_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            RepeatPeriodPicker(period: .constant(.daily))
            RepeatPeriodPicker(period: .constant(.weekly))
            RepeatPeriodPicker(period: .constant(.monthly))
        }
        .environment(\.colorScheme, .dark)
    }
}
