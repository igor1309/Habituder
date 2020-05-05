//
//  Ext+Collection.swift
//  Habituder
//
//  Created by Igor Malyarov on 05.05.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import Foundation

extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        return Array(self.enumerated())
    }
}
