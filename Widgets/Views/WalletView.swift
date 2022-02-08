//
//  WalletView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct WalletView: View {
    
    let address: String
    let title: String?
    
    var body: some View {
        Text("Wallet")
    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                WalletView(
                    address: "0x000",
                    title: "123"
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
