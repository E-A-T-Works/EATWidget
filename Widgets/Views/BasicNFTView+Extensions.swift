//
//  NFTView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

extension BasicNFTView {
    init(item: NFT, displayInfo: Bool) {
        contractAddress = item.address
        tokenId = item.tokenId
        imageUrl = item.imageUrl
        assetTitle = item.title
        collectionTitle = item.collection?.title
        backgroundColor = nil
        self.displayInfo = displayInfo
    }
}

extension BasicNFTView {
    init(item: NFT) {
        contractAddress = item.address
        tokenId = item.tokenId
        imageUrl = item.imageUrl
        assetTitle = item.title
        collectionTitle = item.collection?.title
        backgroundColor = nil
        displayInfo = false
    }
}
