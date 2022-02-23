//
//  GalleryView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/16/22.
//

import Foundation
import UIKit

extension GalleryView {
    init(list: [NFTObject]) {
        self.list = list.map {
            GalleryItem(
                address: $0.address!,
                tokenId: $0.tokenId!,
                image: UIImage(data: $0.image!.blob!)!,
                title: $0.title,
                text: $0.text
            )
        }
    }
}
