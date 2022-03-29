//
//  CarouselCard.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/9/22.
//

import SwiftUI
import AVKit


struct CarouselCardContent {
    let title: String
    let text: String
    let animationUrl: URL
}

struct CarouselCard: View {
    
    let title: String
    let text: String
    let animationUrl: URL
    
    var body: some View {
        VStack {
            
            Spacer()
        
            LoopingPlayer(animationUrl: animationUrl)
            
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding(64)
//                .opacity(0.14)

            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 16, design: .monospaced))
                            .fontWeight(.black)
                        
                        Text(text)
                            .font(.system(size: 12, design: .monospaced))
                            .opacity(0.64)
                    }
                    Spacer()
                }
                
                Spacer()

            }
            .padding()
        }
    }
}

struct CarouselCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CarouselCard(
                title: "Title",
                text: "Text",
                animationUrl: Bundle.main.url(
                    forResource: "tutorial-01",
                    withExtension: "MOV"
                )!
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
