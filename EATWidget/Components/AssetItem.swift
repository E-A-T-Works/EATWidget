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
    let title: String?
    
    var body: some View {
        HStack {
            AsyncImage(url: imageThumbnailUrl){ image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(title ?? "Untitled")
                HStack {
                    Text(tokenId)
                }
            }
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
                title: TestData.asset.title
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        
    }
}
