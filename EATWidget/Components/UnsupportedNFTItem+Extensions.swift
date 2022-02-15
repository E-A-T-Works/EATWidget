//
//  UnsupportedNFTItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation


extension UnsupportedNFTItem {
    init(item: NFT) {
        address = item.address
        tokenId = item.tokenId
    }
}
