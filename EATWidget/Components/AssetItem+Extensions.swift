//
//  AssetItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation


extension AssetItem {
    init(item: Asset) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageThumbnailUrl = item.imageThumbnailUrl
        title = item.title
    }
}
