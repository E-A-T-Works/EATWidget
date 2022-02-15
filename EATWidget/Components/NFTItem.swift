//
//  NFTItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct NFTItem: View {
    
    let address: String
    let tokenId: String

    let imageThumbnailUrl: URL?
    
    let title: String?
    let text: String?
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: imageThumbnailUrl){ phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                } else {
                    ProgressView()
                }
            }
            .frame(width: 40, height: 40)
            
            HStack {
                HeadingLockup(
                    title: title ?? tokenId,
                    text: text ?? address,
                    size: 12
                )
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct NFTItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTItem(
                address: TestData.nft.address,
                tokenId: TestData.nft.id,
                imageThumbnailUrl: TestData.nft.imageUrl,
                title: TestData.nft.title,
                text: TestData.nft.text
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
