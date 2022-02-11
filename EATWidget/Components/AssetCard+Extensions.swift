//
//  AssetCard+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import Foundation

extension AssetCard {
    init(item: Asset) {
        contractAddress = item.contract.address
        tokenId = item.tokenId
        imageUrl = item.imageUrl
        assetTitle = item.title
        collectionTitle = item.collection?.title
        preferredBackgroundColor = item.backgroundColor
    }
}
