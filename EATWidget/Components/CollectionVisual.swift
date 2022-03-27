//
//  CollectionVisual.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CollectionVisual: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var shouldFill: Bool = true
    
    let url: URL
    
    var body: some View {
        ZStack {
            Color.red
            
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                
//                if shouldFill {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                } else {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                }

            } else {
                Image(systemName: "scribble")
                    .resizable()
                    .scaledToFit()
            }
        }
        .animation(.easeInOut, value: shouldFill)
//        .onTapGesture {
//            shouldFill.toggle()
//        }
    }
}

struct CollectionVisual_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionVisual(
                url: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2F0xf9a423b86afbf8db41d7f24fa56848f56684e43f%2Fbanner.png?alt=media&token=e6f96e72-067e-4c02-bcbe-c5f0d0288e20")!
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
