//
//  AttributeBox+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import Foundation

extension AttributeBox {
    init(item: CachedAttribute) {
        key = item.key
        value = item.value
    }
}
