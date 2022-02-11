//
//  AssetSheetCreator.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct AssetSheetCreator: View {
    
    let username: String?
    let address: String
    let imageUrl: URL?
    
    var body: some View {

        HStack {
//            AsyncImage(url: imageUrl) { phase in
//                if let image = phase.image {
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                } else if phase.error != nil {
//                    Image(
//                        uiImage: UIImage(named: "Placeholder")!
//                    )
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//
//                } else {
//                    ProgressView()
//                }
//            }
//            .frame(width: 40, height: 40)
//            .cornerRadius(20)

            Text(username ?? address)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.bold)
                .lineLimit(1)
            
            Spacer()
        }
        
    }
}

struct AssetSheetCreator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetSheetCreator(
                username: "adrian",
                address: "0x000",
                imageUrl: nil
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
