//
//  TraitBox+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import Foundation

extension TraitBox {
    init(item: NFTTrait) {
        key = item.key
        value = item.value
    }
}
