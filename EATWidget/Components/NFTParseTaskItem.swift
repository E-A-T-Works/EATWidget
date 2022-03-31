//
//  NFTItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI


struct NFTParseTaskItem: View {

    @Environment(\.colorScheme) var colorScheme
    
    let address: String
    let tokenId: String
    
    var title: String?
    var image: UIImage?
    var state: NFTParseTaskState = .pending
    
    var seed: Int = Int.random(in: 0..<6)
    

    
    var loader: String {
        return "spinner-\(String(format: "%02d", seed))"
    }
    
    var fallback: String {
        return colorScheme == .dark ? "eat-w-b-01" : "eat-b-w-01"
    }
    
    var detailIcon: String {
        switch state {
        case .pending: return "circle.dotted"
        case .success: return "checkmark.circle"
        case .failure: return "exclamationmark.circle"
        }
    }
    
    var body: some View {
        HStack {

            switch state {
            case .pending:
                LottieView(name: loader, loopMode: .loop)
                    .frame(width: 40, height: 40)
                    .background(.thickMaterial)
                
            case .success:
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .background(.thickMaterial)
                
            case .failure:
                Image(uiImage: UIImage(named: fallback)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .background(.thickMaterial)
            }
            
            
            VStack(alignment: .leading) {
                Text(title != nil && !title!.isEmpty ? title! : "Untitled")
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
            
            Image(systemName: detailIcon)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .opacity(0.32)

        }.padding(4)
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
