//
//  CreatorItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI

extension CreatorItem {
    init(item: NFTCreator) {
        address = item.address
        title = item.title
        imageUrl = item.imageUrl
    }
}
