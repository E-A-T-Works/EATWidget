//
//  CollectionVisual.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CollectionVisual: View {
    @Environment(\.colorScheme) var colorScheme
    
    let url: URL
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                if colorScheme == .dark {
                    Color.white.opacity(0.04)
                } else {
                    Color.black.opacity(0.04)
                }
                
                if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()

                } else {
                    Image(systemName: "scribble")
                        .resizable()
                        .scaledToFit()
                }
            
            }.frame(width: geo.size.width)
        }
        
    }
}

struct CollectionVisual_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionVisual(
                url: TestData.collection.banner
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
