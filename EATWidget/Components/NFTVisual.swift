//
//  NFTVisual.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct NFTVisual: View {
    
    let imageUrl: URL?    
    let backgroundColor: Color
    
    
    var body: some View {
        CachedAsyncImage(url: imageUrl){ phase in
           if let image = phase.image {
               image
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .background(backgroundColor)
           } else if phase.error != nil {
               Image(systemName: "photo")
                   .resizable()
           } else {
               ProgressView()
           }
        }
    }
}

struct NFTVisual_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTVisual(
                imageUrl: TestData.nft.imageUrl,
                backgroundColor: Color.clear
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
