//
//  AssetItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct AssetItem: View {
    
    let contractAddress: String
    let tokenId: String
    let imageThumbnailUrl: URL?
    
    let assetTitle: String?
    let collectionTitle: String?
    
    var body: some View {
        HStack {
            AsyncImage(url: imageThumbnailUrl){ image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            HStack {
                HeadingLockup(
                    title: assetTitle,
                    text: collectionTitle,
                    fontStyle: .caption
                )
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct AssetItem_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            AssetItem(
                contractAddress: TestData.asset.contract.address,
                tokenId: TestData.asset.tokenId,
                imageThumbnailUrl: TestData.asset.imageThumbnailUrl!,
                assetTitle: TestData.asset.title,
                collectionTitle: TestData.asset.collection?.title
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
