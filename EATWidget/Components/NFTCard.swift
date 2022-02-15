//
//  NFTCard.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct NFTCard: View {
    let address: String
    let tokenId: String

    let imageUrl: URL?
    
    let title: String?
    let text: String?
    
    let preferredBackgroundColor: UIColor?
    
    // MARK: Color resolvers
    
//    @State private var backgroundColor: Color = .clear
//
//    private func resolveColors()  {
//        let derivedColors = Theme.resolveColorsFromImage(
//            imageUrl: imageUrl,
//            preferredBackgroundColor: preferredBackgroundColor
//        )
//        backgroundColor = Color(uiColor: derivedColors.backgroundColor)
//    }
    
    // MARK: Body
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: imageUrl, urlCache: .imageCache){ phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(uiImage: UIImage(named: "Placeholder")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            HStack {
                HeadingLockup(
                    title: title,
                    text: text,
                    size: 12
                )

                Spacer()
            }
            .padding([.leading, .trailing], 4)
            .padding([.top, .bottom], 4)
        }
        .padding([.bottom], 8)
    }
}

struct NFTCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTCard(
                address: TestData.nft.address,
                tokenId: TestData.nft.tokenId,
                imageUrl: TestData.nft.imageUrl,
                title: TestData.nft.title,
                text: TestData.nft.text,
                preferredBackgroundColor: nil
            )
                .frame(width: 300)
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
