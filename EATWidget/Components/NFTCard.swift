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

    let imageUrl: URL
    let animationUrl: URL?
    
    let title: String?
    let text: String?
    
    let preferredBackgroundColor: UIColor?

    // MARK: Body
    
    var body: some View {
        VStack {
            
            NFTVisual(
                imageUrl: imageUrl,
                animationUrl: animationUrl,
                backgroundColor: Color.clear
            )
                        
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
                imageUrl: TestData.nft.imageUrl!,
                animationUrl: TestData.nft.animationUrl,
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
