//
//  WalletItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import SwiftUI

struct WalletItem: View {
    let address: String
    let title: String?
    
    
    var body: some View {
        HStack {
            
            HeadingLockup(
                title: title != nil && !title!.isEmpty ? title : address.formattedWeb3,
                text: nil,
                size: 16
            )
            
            Spacer()
   
        }
    }
}

struct WalletItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WalletItem(address: "0x00023232324242", title: nil)
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
        
    }
}
