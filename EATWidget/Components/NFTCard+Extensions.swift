//
//  NFTCard+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import Foundation
import SwiftUI

extension NFTCard {
    init(item: NFTObject) {
        address = item.address!
        tokenId = item.tokenId!
        image = UIImage(data: item.image!.blob!)!
        animationUrl = item.animationUrl
        title = item.title
        text = nil
    }
}
