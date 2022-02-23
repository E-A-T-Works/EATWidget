//
//  NFTView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//


// MARK: - NFT

extension BasicNFTView {
    init(item: NFT, displayInfo: Bool) {
        contractAddress = item.address
        tokenId = item.tokenId
        imageUrl = nil
        assetTitle = item.title
        collectionTitle = nil
        backgroundColor = nil
        self.displayInfo = displayInfo
    }
}

extension BasicNFTView {
    init(item: NFT) {
        contractAddress = item.address
        tokenId = item.tokenId
        imageUrl = nil
        assetTitle = item.title
        collectionTitle = nil
        backgroundColor = nil
        displayInfo = false
    }
}


// MARK: - CachedNFT


extension BasicNFTView {
    init(item: CachedNFT, displayInfo: Bool) {
        contractAddress = item.address!
        tokenId = item.tokenId!
        imageUrl = item.imageUrl
        assetTitle = item.title
        collectionTitle = nil
        backgroundColor = nil
        self.displayInfo = displayInfo
    }
}

extension BasicNFTView {
    init(item: CachedNFT) {
        contractAddress = item.address!
        tokenId = item.tokenId!
        imageUrl = item.imageUrl
        assetTitle = item.title
        collectionTitle = nil
        backgroundColor = nil
        displayInfo = false
    }
}
