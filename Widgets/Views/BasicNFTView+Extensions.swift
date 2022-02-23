//
//  NFTView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//


// MARK: - NFT
import UIKit

extension BasicNFTView {
    init(item: NFTObject, displayInfo: Bool) {
        address = item.address!
        tokenId = item.tokenId!
        image = UIImage(data: item.image!.blob!)!
        title = item.title
        text = item.text
        self.displayInfo = displayInfo
    }
}

extension BasicNFTView {
    init(item: NFTObject) {
        address = item.address!
        tokenId = item.tokenId!
        image = UIImage(data: item.image!.blob!)!
        title = item.title
        text = item.text
        displayInfo = false
    }
}
