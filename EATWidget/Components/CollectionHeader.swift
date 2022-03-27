//
//  CollectionHeader.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CollectionHeader: View {
    
    let title: String
    let address: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(title)")
                    .font(.system(size: 28.0, design: .monospaced))
                    .fontWeight(.black)
                    .lineLimit(1)
                
                Text("\(address.formattedWeb3)")
                    .font(.system(size: 12.0, design: .monospaced))
                    .fontWeight(.light)
                    .lineLimit(1)
            }
            
            Spacer()
        }
    }
}

struct CollectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionHeader(
                title: "Every Icon",
                address: "0x00000000000000000"
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
