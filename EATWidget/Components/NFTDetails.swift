//
//  NFTDetails.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct NFTDetails: View {
    
    let address: String
    let tokenId: String
    let standard: String?
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            SectionTitle(text: "Details")
            
            VStack {
                TableItem(key: "Contract Address", value: address.formattedWeb3)
                
                TableItem(key: "Token ID", value: tokenId.formattedWeb3)
                
                if standard != nil {
                    TableItem(key: "Token Standard", value: standard!)
                }
                
            }
        }
        
        

    }
}

struct NFTDetails_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            NFTDetails(
                address: TestData.nft.address,
                tokenId: TestData.nft.tokenId,
                standard: ""
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
