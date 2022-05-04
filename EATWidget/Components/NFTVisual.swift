//
//  NFTVisual.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//
//  References:
//      https://designcode.io/swiftui-handbook-play-video-with-avplayer
//      https://schwiftyui.com/swiftui/playing-videos-on-a-loop-in-swiftui/
//

import SwiftUI

struct NFTVisual: View {
    @Environment(\.colorScheme) var colorScheme
    
    let image: UIImage
    let animationUrl: URL?
    let simulationUrl: URL?
    
    @State var contentMode: ContentMode = .fit

    var body: some View {
        ZStack {

            if simulationUrl != nil {
                WebView(url: simulationUrl!)
            } else if animationUrl != nil {
                LoopingPlayer(animationUrl: animationUrl!)
            } else {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .animation(.easeInOut, value: contentMode)
                    .onTapGesture {
                        if contentMode == .fit {
                            contentMode = .fill
                        } else {
                            contentMode = .fit
                        }
                    }
            }
        }
    }
}

struct NFTVisual_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTVisual(
                image: TestData.nft.image,
                animationUrl: TestData.nft.animationUrl,
                simulationUrl: TestData.nft.simulationUrl
            )
        }
        .frame(width: 500, height: 500)
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
