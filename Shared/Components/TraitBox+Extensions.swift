//
//  TraitBox+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import Foundation

extension TraitBox {
    init(item: NFTAttribute) {
        key = item.key
        value = item.value
    }
}
