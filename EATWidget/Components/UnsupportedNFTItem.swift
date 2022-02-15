//
//  UnsupportedNFTItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI

struct UnsupportedNFTItem: View {
    let address: String
    let tokenId: String
    
    var body: some View {
        HStack {
            HeadingLockup(title: tokenId, text: address, size: 12)
        }
    }
}

struct UnsupportedNFTItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            UnsupportedNFTItem(
                address: TestData.nft.address,
                tokenId: TestData.nft.tokenId
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
