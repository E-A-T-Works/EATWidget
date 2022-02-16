//
//  GalleryView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI
import WidgetKit


struct GalleryItem {
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let assetTitle: String?
    let collectionTitle: String?
    let backgroundColor: UIColor?
}


struct GalleryView: View {
    // MARK: Parameters

    @Environment(\.widgetFamily) var family: WidgetFamily
    
    let list: [GalleryItem]

    
    // MARK: Content
    
    var body: some View {
        
        switch family {
        case .systemSmall:
            UnsupportedView()
        case .systemMedium:
            MediumGalleryView(list: list)
        case .systemLarge:
            UnsupportedView()
        case .systemExtraLarge:
            UnsupportedView()
        @unknown default:
            UnsupportedView()
        }
        
    }
}

struct MediumGalleryView: View {
    let list: [GalleryItem]
    
    let inset: CGFloat = 16
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(list, id: \.tokenId) { item in
                    VStack {
                        SmallBasicNFTView(
                            contractAddress: item.contractAddress,
                            tokenId: item.tokenId,
                            imageUrl: item.imageUrl,
                            assetTitle: item.assetTitle,
                            collectionTitle: item.collectionTitle,
                            backgroundColor: item.backgroundColor,
                            displayInfo: false
                        )
                    }
                }
            }
            .padding(.horizontal, inset)
            .padding(.top, 24)
            .padding(.bottom, 0)
            
            VStack {
                HStack {
                    Branding()
                        .frame(width: 24, height: 24)
                        .padding(inset / 3)
                }
                Spacer()
            }
        }
    }
}




struct GalleryNiew_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                GalleryView(
                    list: Array(
                        repeating: .init(contractAddress: TestData.nft.address, tokenId: TestData.nft.tokenId, imageUrl: TestData.nft.imageUrl, assetTitle: TestData.nft.title, collectionTitle: TestData.nft.collection?.title, backgroundColor: nil),
                        count: 4
                    )
                )
            }.previewContext(
                WidgetPreviewContext(family: .systemMedium)
            )

        }
    }
}
