//
//  CollectionItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import Foundation
import UIKit

extension CollectionItem {
    init(item: CachedCollection) {
        address = item.address!
        thumbnail = item.thumbnail != nil ? UIImage(data: (item.thumbnail?.blob)!)! : nil
        title = item.title
    }
}
