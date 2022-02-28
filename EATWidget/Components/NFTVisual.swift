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
    let simulationUrl: URL?
    let animationUrl: URL?
    
    var body: some View {
        ZStack {
            if simulationUrl != nil {
                WebView(url: simulationUrl!)
            } else if animationUrl != nil {
                LoopingPlayer(animationUrl: animationUrl!)
            } else {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct NFTVisual_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTVisual(
                image: TestData.nft.image,
                simulationUrl: URL(string: "https://everyicon.xyz/icon/?tokenId=40"),
                animationUrl: TestData.nft.animationUrl
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
