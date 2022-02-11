//
//  AssetCard.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct AssetCard: View {
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    
    let assetTitle: String?
    let collectionTitle: String?
    
    let preferredBackgroundColor: UIColor?
    
    @State private var backgroundColor: Color = .clear
    
    private func resolveColors()  {
        let derivedColors = Theme.resolveColorsFromImage(
            imageUrl: imageUrl,
            preferredBackgroundColor: preferredBackgroundColor
        )
        backgroundColor = Color(uiColor: derivedColors.backgroundColor)
    }
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: imageUrl){ phase in
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
            .background(backgroundColor)
            
            HStack {
                HeadingLockup(
                    title: assetTitle,
                    text: collectionTitle,
                    fontStyle: .caption
                )

                Spacer()
            }
            .padding([.leading, .trailing], 4)
            .padding([.top, .bottom], 4)
        }
        .padding([.bottom], 8)
        .onAppear(perform: resolveColors)
    }
}

struct AssetCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetCard(
                contractAddress: TestData.asset.contract.address,
                tokenId: TestData.asset.tokenId,
                imageUrl: TestData.asset.imageUrl!,
                assetTitle: TestData.asset.title,
                collectionTitle: TestData.asset.collection?.title,
                preferredBackgroundColor: TestData.asset.backgroundColor
            )
                .frame(width: 300)
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
