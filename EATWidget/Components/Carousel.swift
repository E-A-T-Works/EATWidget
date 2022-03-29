//
//  Carousel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/9/22.
//

import SwiftUI

struct Carousel: View {

    @State private var index = 0
    
    var list: [CarouselCardContent] = []
    
    var body: some View {
        VStack {
            
            TabView(selection: $index) {
                ForEach(0..<list.count, id: \.self) { index in
                    CarouselCard(
                        title: list[index].title,
                        text: list[index].text,
                        animationUrl: list[index].animationUrl
                    )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            if list.count > 1 {
                HStack(spacing: 4) {
                    ForEach((0..<list.count), id: \.self) { index in
                        Circle()
                            .fill(index == self.index ? Color.black : Color.black.opacity(0.24))
                            .frame(width: 8, height: 8)

                    }
                }
                .padding()
            }
        }
    }
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        Carousel()
    }
}
