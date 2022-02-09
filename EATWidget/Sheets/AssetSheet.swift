//
//  AssetSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct AssetSheet: View {
    
    let contractAddress: String
    let tokenId: String
    
    var body: some View {
        Text("Hello \(contractAddress) \(tokenId)")
    }
}

struct AssetSheet_Previews: PreviewProvider {
    static var previews: some View {
        AssetSheet(
            contractAddress: "0x00",
            tokenId: "123"
        )
    }
}
