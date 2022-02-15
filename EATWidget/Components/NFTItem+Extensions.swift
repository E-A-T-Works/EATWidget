//
//  NFTItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

extension NFTItem {
    init(item: NFT) {
        address = item.address
        tokenId = item.tokenId
        thumbnailUrl = item.thumbnailUrl ?? item.imageUrl
        title = item.title
        text = item.collection?.title
    }
}
