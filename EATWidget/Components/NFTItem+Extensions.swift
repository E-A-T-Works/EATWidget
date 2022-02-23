//
//  NFTItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

extension NFTItem {
    init(item: NFT) {
        address = item.address
        tokenId = item.tokenId
        image = item.image
        title = item.title
        text = item.text
    }
}


extension NFTItem {
    init(item: NFTObject) {
        address = item.address!
        tokenId = item.tokenId!
        image = UIImage(data: item.image!.blob!)!
        title = item.title
        text = item.text
    }
}
