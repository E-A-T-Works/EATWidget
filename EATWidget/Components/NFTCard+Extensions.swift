//
//  NFTCard+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import Foundation
import SwiftUI

extension NFTCard {
    init(item: CachedNFT) {
        address = item.address ?? ""
        tokenId = item.tokenId ?? ""
        image = item.image != nil ? UIImage(data: item.image!.blob!)! : UIImage(systemName: "scribble")!
        animationUrl = item.animationUrl
        title = item.title ?? ""
        text = nil
    }
}
