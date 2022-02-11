//
//  AssetSheetDetails.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct AssetSheetDetails: View {
    
    let contractAddress: String
    let tokenId: String
    let tokenStandard: String?
    
    var body: some View {
        
        VStack {
            TableItem(key: "Contract Address", value: contractAddress)
            
            TableItem(key: "Token ID", value: tokenId)
            
            if tokenStandard != nil {
                TableItem(key: "Token Standard", value: tokenStandard!)
            }
            
        }

    }
}

struct AssetSheetDetails_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            AssetSheetDetails(
                contractAddress: TestData.asset.contract.address,
                tokenId: TestData.asset.tokenId,
                tokenStandard: nil
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
