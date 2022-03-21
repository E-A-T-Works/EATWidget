//
//  NFTItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

enum NFTItemState {
    case Pending
    case Supported
    case Unsupported
}


struct NFTItem: View {
    let title: String
    let address: String
    let tokenId: String
    
    var image: UIImage?
    var state: NFTItemState = .Pending
    
    var body: some View {
        HStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                    .padding(4)
                    .background(.thickMaterial)
                    .cornerRadius(4)
            } else {
                Image(systemName: "scribble")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                    .padding(4)
                    .background(.thickMaterial)
                    .cornerRadius(4)
            }
            
            
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 12.0, design: .monospaced))
                    .fontWeight(.black)
                    .lineLimit(1)
                
                Text("Contract: \("0x002323203232323232".formattedWeb3)")
                    .font(.system(size: 12.0, design: .monospaced))
                    .lineLimit(1)
                
                Text("Token Id: \("1212121212sdsdsdsds")")
                    .font(.system(size: 12.0, design: .monospaced))
                    .lineLimit(1)
            }
            
            Spacer()
            
            switch state {
            case .Pending: Image(systemName: "circle.dotted")
            case .Supported: Image(systemName: "checkmark.circle")
            case .Unsupported: Image(systemName: "x.circle")
            }
        }
        .padding()
    }
}

struct NFTItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTItem(
                title: "Title",
                address: "0x00000000000000",
                tokenId: "#012",
                state: .Pending
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
