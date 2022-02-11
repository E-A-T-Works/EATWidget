//
//  AssetSheetVisual.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct AssetSheetVisual: View {
    
    let imageUrl: URL
    let backgroundColor: Color
    
    var body: some View {
        CachedAsyncImage(url: imageUrl){ image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(backgroundColor)
        } placeholder: {
            ProgressView()
        }
    }
}

struct AssetSheetVisual_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetSheetVisual(
                imageUrl: TestData.asset.imageUrl!,
                backgroundColor: TestData.asset.backgroundColor != nil ? Color(uiColor: TestData.asset.backgroundColor!) :
                Color.black
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
