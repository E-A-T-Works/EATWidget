//
//  WalletItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct WalletItem: View {
    
    let address: String
    let title: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title ?? "Untitled")
                Text(address)
            }
        }
    }
}

struct WalletItem_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            WalletItem(
                address: "123",
                title: "Something"
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
    }
}
