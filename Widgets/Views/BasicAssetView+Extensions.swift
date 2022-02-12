//
//  AssetView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

extension BasicAssetView {
    init(item: Asset, displayInfo: Bool) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageUrl = item.imageUrl
        assetTitle = item.title
        collectionTitle = item.collection?.title
        backgroundColor = item.backgroundColor
        self.displayInfo = displayInfo
    }
}

extension BasicAssetView {
    init(item: Asset) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageUrl = item.imageUrl
        assetTitle = item.title
        collectionTitle = item.collection?.title
        backgroundColor = item.backgroundColor
        displayInfo = false
    }
}
