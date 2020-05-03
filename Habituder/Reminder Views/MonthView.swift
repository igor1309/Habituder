//
//  MonthView.swift
//  Habituder
//
//  Created by Igor Malyarov on 02.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct MonthView: View {
    @Binding var selected: Int
    var maxWidth: CGFloat
    var maxHeight: CGFloat
    
    private func cell(row: Int, col: Int, cellSize: CGFloat) -> some View {
        let day = row * 7 + col
        
        let calendar = Calendar.current
        let timeZone = TimeZone.autoupdatingCurrent
        let today = calendar.dateComponents(in: timeZone, from:Date()).day!
        
        return Text(day <= 31 ? "\(day)" : " ")
            .frame(width: cellSize, height: cellSize)
            .foregroundColor(self.selected == day
                ? Color.orange
                : day == today
                ? Color.primary
                : Color.secondary)
            .font(cellSize < 36 ? .caption : .body)
            .background(self.selected == day ? Color.tertiarySystemBackground : Color.clear)
            .border(Color.systemGray5, width: 0.5)
            .contentShape(Rectangle())
            .onTapGesture {
                //  MARK: ADD HAPTIC
                //
                withAnimation {
                    //    if self.selected == nil {
                    //        self.selected = day
                    //        return
                    //    }
                    //
                    //    if self.selected == day {
                    //        self.selected = nil
                    //        return
                    //    }
                    
                    self.selected = day
                }
        }
    }
    
    var body: some View {
        let cellSize = min(maxWidth / 7, maxHeight / 5)
        //        print("maxWidth: \(maxWidth) | maxHeight: \(maxHeight) | cellSize: \(cellSize)")
        
        return VStack(spacing: 0) {
            ForEach(0...4, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { col in
                        self.cell(row: row, col: col, cellSize: cellSize)
                    }
                }
            }
        }
        .frame(width: cellSize * 7, height: cellSize * 5)
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            MonthView(selected: .constant(4), maxWidth: 350, maxHeight: 400)
        }
        .environment(\.colorScheme, .dark)
    }
}
