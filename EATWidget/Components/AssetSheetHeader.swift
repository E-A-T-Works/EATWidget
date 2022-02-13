//
//  AssetSheetHeader.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct AssetSheetHeader: View {
    
    let assetTitle: String?
    let collectionTitle: String?
    
    var body: some View {
        HStack {
            HeadingLockup(
                title: assetTitle,
                text: collectionTitle,
                size: 12
            )
            
            Spacer()
            
            EthPrice()
        }
    }
}

struct AssetSheetHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetSheetHeader(
                assetTitle: "Asset Title",
                collectionTitle: "Collection Title"
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
