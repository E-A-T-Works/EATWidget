//
//  NFTHeader.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct NFTHeader: View {
    
    let title: String?
    let text: String?
    
    var body: some View {
        HStack {
            HeadingLockup(
                title: title,
                text: text,
                size: 14
            )
            
            Spacer()
            
            EthPrice()
        }
    }
}

struct NFTHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTHeader(
                title: "Asset Title",
                text: "Collection Title"
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
