//
//  AssetView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

extension AssetView {
    init(item: Asset, displayInfo: Bool) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageThumbnailUrl = item.imageThumbnailUrl
        title = item.title
        backgroundColor = item.backgroundColor
        self.displayInfo = displayInfo
    }
}

extension AssetView {
    init(item: Asset) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageThumbnailUrl = item.imageThumbnailUrl
        title = item.title
        backgroundColor = item.backgroundColor
        displayInfo = false
    }
}
