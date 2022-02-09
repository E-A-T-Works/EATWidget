//
//  AssetCard.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct AssetCard: View {
    
    @State private var backgroundColor: Color = .clear
    @State private var foregroundColor: Color = .black
    
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let title: String?
    let preferredBackgroundColor: String?
    
    private func resolveColors()  {
        if(preferredBackgroundColor != nil) {
            let uiColor = UIColor(hexString: preferredBackgroundColor!)!
            backgroundColor = Color(uiColor: uiColor)
            foregroundColor = uiColor.isDarkColor ? .white : .black
            return
        }
        
        if(imageUrl == nil) {
            backgroundColor = .clear
            foregroundColor = .black
            return
        }
        
        let data = try? Data(contentsOf: imageUrl!)
        let uiImage = UIImage(data: data!)
        
        let uiColor = uiImage?.averageColor ?? .clear
        
        backgroundColor = Color(uiColor: uiColor)
        foregroundColor = uiColor.isDarkColor ? .white : .black
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                AsyncImage(url: imageUrl){ phase in
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
                .frame(
                    width: geo.size.width,
                    height: geo.size.width
                )
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(title ?? "Untitled")
                            .font(
                                .system(
                                    size: 18,
                                    weight: .bold,
                                    design: .default
                                )
                            )
                            .foregroundColor(foregroundColor)

                        Text(tokenId)
                            .font(
                                .system(
                                    size: 12,
                                    weight: .regular,
                                    design: .default
                                )
                            )
                            .foregroundColor(foregroundColor.opacity(0.80))
                    }
                    
                    Spacer()
                }
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 8)
                .frame(width: geo.size.width)
                .frame(height: 50)
            }
            .background(backgroundColor)
            .onAppear(perform: resolveColors)
        }
    }
}

struct AssetCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            AssetCard(
                contractAddress: TestData.asset.contract.address,
                tokenId: TestData.asset.tokenId,
                imageUrl: TestData.asset.imageUrl!,
                title: TestData.asset.title,
                preferredBackgroundColor: TestData.asset.backgroundColor
            )
                .frame(width: geo.size.width)
                .frame(height: geo.size.width + 60)
        }
        
    }
}
