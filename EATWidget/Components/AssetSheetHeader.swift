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
            VStack(alignment: .leading) {
                Text(assetTitle ?? "Untitled")
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.black)
                    .lineLimit(1)
                
                if collectionTitle != nil {
                    Text(collectionTitle!)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.light)
                        .lineLimit(1)
                }
            }
            
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
