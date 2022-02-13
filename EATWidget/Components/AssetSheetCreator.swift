//
//  AssetSheetCreator.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct AssetSheetCreator: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    
    let address: String?
    let username: String?
    let imageUrl: URL?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            SectionTitle(text: "About the artist")
            
            Button(action: {
                if address == nil { return }
                openURL(URL(string: "https://opensea.io/\(address!)")!)
            }, label: {
                HStack {
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if phase.error != nil {
                            Image(
                                uiImage: UIImage(named: "Placeholder")!
                            )
                            .resizable()
                            .aspectRatio(contentMode: .fit)

                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 28, height: 28)
                    .cornerRadius(14)

                    Text(username != nil ? "@\(username!)" : address ?? "Unknown")
                        .font(.system(size: 14, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(
                            colorScheme == .dark ? Color.white : Color.black
                        )
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(uiImage: UIImage(systemName: "arrow.up.right")!)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(
                            colorScheme == .dark ? Color.white : Color.black
                        )
                        .frame(width: 8, height: 8)
                }
            })
        }
    }
}

struct AssetSheetCreator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetSheetCreator(
                address: "0x000",
                username: "adrian",
                imageUrl: nil
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
