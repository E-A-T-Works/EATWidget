//
//  CollectionItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import SwiftUI

struct CollectionItem: View {
    @Environment(\.colorScheme) var colorScheme

    let address: String
    
    let title: String?
    let thumbnail: UIImage?
    
    private var fallback: UIImage {
        
        let seed = Int.random(in: 0..<7)
        
        return UIImage(
            named: colorScheme == .dark
                ? "eat-w-b-\(String(format: "%02d", seed))"
                : "eat-b-w-\(String(format: "%02d", seed))"
        )!
    }
    
    
    var body: some View {
        HStack {
            
            ZStack {
                if colorScheme == .dark {
                    Color.white.opacity(0.12)
                } else {
                    Color.black.opacity(0.04)
                }
                
                
                Image(uiImage: (thumbnail ?? fallback)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24, alignment: .center)
                    .clipped()
                
            }.frame(width: 24, height: 24, alignment: .center)
                
            Text(title ?? address.formattedWeb3)
                .font(.system(size: 16.0, design: .monospaced))
                .fontWeight(.black)
                .lineLimit(1)
            
            Spacer()
            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.black)
//                .opacity(0.5)
        }
    }
}

struct CollectionItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionItem(
                address: "0x00000000000000",
                title: "Some Collection",
                thumbnail: nil
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
