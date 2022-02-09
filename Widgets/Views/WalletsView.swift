//
//  WalletView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit


struct WalletsViewData {
    let address: String
    let title: String?
    let balance: String?
}

struct WalletsView: View {
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    let items: [WalletsViewData]
    
    var body: some View {
        
        ZStack {
        
            HStack {
                ForEach(items, id: \.address) { item in
                
                    VStack {
                        
                        Text(item.title ?? "Untitled")
                        Text(item.balance ?? "0")
                        
                    }
                    
                }
            }
            
        }
        
        
    }
}

struct WalletsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                WalletsView(
                    items: [
                        WalletsViewData(
                            address: "0x00",
                            title: "Some Title",
                            balance: "18789428385416666533"
                        )
                    ]
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
