//
//  AssetCard.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct AssetCard: View {
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let title: String?
    let preferredBackgroundColor: UIColor?
    
    @State private var backgroundColor: Color = .clear
    
    private func resolveColors()  {
        let derivedColors = Theme.resolveColorsFromImage(
            imageUrl: imageUrl,
            preferredBackgroundColor: preferredBackgroundColor
        )
        backgroundColor = Color(uiColor: derivedColors.backgroundColor)
    }
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: imageUrl){ phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                } else {
                    ProgressView()
                }
            }
            .background(backgroundColor)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(title ?? "Untitled")
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    Text(tokenId)
                        .font(.caption)
                        .fontWeight(.light)
                        .lineLimit(3)
                }
                Spacer()
            }
            .padding([.leading, .trailing], 4)
            .padding([.top, .bottom], 4)
        }
        .onAppear(perform: resolveColors)
    }
}

struct AssetCard_Previews: PreviewProvider {
    static var previews: some View {
        AssetCard(
            contractAddress: TestData.asset.contract.address,
            tokenId: TestData.asset.tokenId,
            imageUrl: TestData.asset.imageUrl!,
            title: TestData.asset.title,
            preferredBackgroundColor: TestData.asset.backgroundColor
        )
        .padding()
    }
}
