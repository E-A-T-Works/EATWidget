//
//  EthPrice.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct EthPrice: View {
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "Eth")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:12)
            
            Text("2.1")
                .font(.system(.body, design: .monospaced))
                .lineLimit(1)
        }
    }
}

struct EthPrice_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EthPrice()
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
