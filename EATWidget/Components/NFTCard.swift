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

    let image: UIImage
    let animationUrl: URL?
    
    let title: String?
    let text: String?
    

    // MARK: Body
    
    var body: some View {
        VStack {

            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                
                        
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
                image: UIImage(named: "eat-b-w-0")!,
                animationUrl: TestData.nft.animationUrl,
                title: TestData.nft.title,
                text: nil
            )
                .frame(width: 300)
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
