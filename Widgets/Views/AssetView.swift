//
//  AssetView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct AssetView: View {
    
    let contractAddress: String
    let tokenId: String
    let imageThumbnailUrl: URL?
    let title: String?
    let backgroundColor: String?
    
    var body: some View {
        Text("Asset")
        Text(tokenId)
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                AssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageThumbnailUrl: TestData.asset.imageThumbnailUrl,
                    title: TestData.asset.title,
                    backgroundColor: TestData.asset.backgroundColor
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
