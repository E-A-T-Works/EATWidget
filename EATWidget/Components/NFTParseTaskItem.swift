//
//  NFTItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI


struct NFTParseTaskItem: View {
    let address: String
    let tokenId: String
    
    var title: String?
    var image: UIImage?
    var state: NFTParseTaskState? = .pending
    
    var body: some View {
        HStack {
//            if image != nil {
//                Image(uiImage: image!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 40, height: 40)
//                    .padding(4)
//                    .background(.thickMaterial)
//                    .cornerRadius(4)
//            } else {
//                Image(systemName: "scribble")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 40, height: 40)
//                    .padding(4)
//                    .background(.thickMaterial)
//                    .cornerRadius(4)
//            }

            LottieView()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(title ?? "Untitled")
                    .font(.system(size: 12.0, design: .monospaced))
                    .fontWeight(.black)
                    .lineLimit(1)
                
                Text("Contract: \(address.formattedWeb3)")
                    .font(.system(size: 12.0, design: .monospaced))
                    .lineLimit(1)
                
                Text("Token Id: \(tokenId)")
                    .font(.system(size: 12.0, design: .monospaced))
                    .lineLimit(1)
            }
            
            Spacer()
            
            switch state {
            case .pending: Image(systemName: "circle.dotted")
            case .success: Image(systemName: "checkmark.circle")
            case .failure: Image(systemName: "x.circle")
            case .none: Image(systemName: "circle.dotted")
            }
        }
    }
}

struct NFTParseTaskItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTParseTaskItem(
                address: "0x00000000000000",
                tokenId: "#012"
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
