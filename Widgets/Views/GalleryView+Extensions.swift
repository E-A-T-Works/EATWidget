//
//  GalleryView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/16/22.
//

import Foundation


extension GalleryView {
    init(list: [CachedNFT?]) {
        self.list = list.filter { $0 != nil }.map {
            GalleryItem(
                contractAddress: ($0?.address)!,
                tokenId: ($0?.tokenId)!,
                imageUrl: ($0?.imageUrl)!,
                assetTitle: $0?.title,
                collectionTitle: nil,
                backgroundColor: nil
            )
        }
    }
}
