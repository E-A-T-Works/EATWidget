//
//  CarouselCard.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/9/22.
//

import SwiftUI


struct CarouselCardContent {
    let title: String
    let text: String
    let image: Image
}

struct CarouselCard: View {
    
    let title: String
    let text: String
    let image: Image
    
    
    var body: some View {
        VStack {
            
            Spacer()
            
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(64)
                .opacity(0.14)
            
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 12, design: .monospaced))
                            .fontWeight(.bold)
                        
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
                image: Image(systemName: "scribble")
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
