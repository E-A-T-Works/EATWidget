//
//  NFTItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

extension NFTItem {
    init(item: NFT, state: NFTItemState) {

        title = item.title ?? "Untitled"
        address = item.address
        tokenId = item.tokenId
        
        image = item.image
        self.state = state
    }
}


extension NFTItem {
    init(item: NFTObject, state: NFTItemState) {
        title = item.title ?? "Untitled"
        address = item.address!
        tokenId = item.tokenId!
        
        image = UIImage(data: item.image!.blob!)!
        self.state = state
    }
}
