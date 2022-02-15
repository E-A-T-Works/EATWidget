//
//  NFTCard+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import Foundation

extension NFTCard {
    init(item: NFT) {
        address = item.address
        tokenId = item.tokenId
        imageUrl = item.imageUrl
        title = item.title
        text = item.collection?.title
        preferredBackgroundColor = nil
    }
}
