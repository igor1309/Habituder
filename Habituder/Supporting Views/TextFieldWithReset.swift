//
//  TextFieldWithReset.swift
//  Habituder
//
//  Created by Igor Malyarov on 23.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

struct TextFieldWithReset: View {
    var title: String
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        HStack(spacing: 0) {
            TextField(title, text: $text)
            
            if text.isNotEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.tertiary)
                        .imageScale(.small)
                        .opacity(0.8)
                        .padding(.vertical, 8)
                        .padding(.leading)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct TextFieldWithResetTesting: View {
    @State private var text: String = ""
    
    var body: some View {
        Form {
            TextField("title", text: $text)
            TextFieldWithReset("title", text: $text)
        }
    }
}

struct TextFieldWithReset_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithResetTesting()
    }
}
