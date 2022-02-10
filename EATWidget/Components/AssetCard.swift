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
        
        let uiColor = uiImage?.averageColor?.tint ?? .clear
        
        backgroundColor = Color(uiColor: uiColor)
        foregroundColor = uiColor.isDarkColor ? .white : .black
    }
    
    var body: some View {
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
            
            HStack {
                VStack(alignment: .leading) {
                    Text(title ?? "Untitled")
                    Text(tokenId)
                }
                Spacer()
            }
            .padding([.leading, .trailing], 4)
            .padding([.top, .bottom], 4)
            
        }
        .background(backgroundColor)
        .cornerRadius(0)
        .onAppear(perform: resolveColors)
        
    
        
        
    }
}

struct AssetCard_Previews: PreviewProvider {
    static var previews: some View {
        AssetCard(
            contractAddress: TestData.assets[1].contract.address,
            tokenId: TestData.assets[1].tokenId,
            imageUrl: TestData.assets[1].imageUrl!,
            title: TestData.assets[1].title,
            preferredBackgroundColor: TestData.assets[1].backgroundColor
        )
        .padding()
    }
}
