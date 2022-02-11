//
//  AssetItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

extension AssetItem {
    init(item: Asset) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageThumbnailUrl = item.imageThumbnailUrl
        assetTitle = item.title
        collectionTitle = item.collection?.title
    }
}
