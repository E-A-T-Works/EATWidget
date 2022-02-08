//
//  AssetView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//


extension AssetView {
    init(item: Asset) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageThumbnailUrl = item.imageThumbnailUrl
        title = item.title
        backgroundColor = item.backgroundColor
    }
}
