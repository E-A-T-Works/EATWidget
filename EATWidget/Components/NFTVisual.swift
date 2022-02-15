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
    let imageUrl: URL
    let animationUrl: URL?
    let backgroundColor: Color

    var body: some View {
        ZStack {
            if animationUrl != nil {
                LoopingPlayer(animationUrl: animationUrl!)
            } else {
                CachedAsyncImage(url: imageUrl, urlCache: .imageCache){ phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(uiImage: UIImage(named: "Placeholder")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .background(backgroundColor)
            }
        }
    }
}

struct NFTVisual_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NFTVisual(
                imageUrl: TestData.nft.imageUrl!,
                animationUrl: URL(string: "https://res.cloudinary.com/nifty-gateway/video/upload/v1613068880/A/SuperPlastic/Kranky_Metal_As_Fuck_Black_Edition_Superplastic_X_SketOne_wyhzcf_hivljh.mp4"),
                backgroundColor: Color.clear
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
