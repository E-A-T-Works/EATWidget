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

    let image: UIImage
    
    let title: String?
    let text: String?
    
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            HStack {
                HeadingLockup(
                    title: title ?? tokenId,
                    text: nil,
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
                image: UIImage(named: "eat-b-w-0")!,
                title: TestData.nft.title,
                text: TestData.nft.text
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
