//
//  GalleryNFTView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI
import WidgetKit

struct GalleryNFTItem {
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let assetTitle: String?
    let collectionTitle: String?
    let backgroundColor: UIColor?
}


struct GalleryNFTView: View {
    // MARK: Parameters

    @Environment(\.widgetFamily) var family: WidgetFamily
    
    let list: [GalleryNFTItem]
    
    // MARK: Content
    
    var body: some View {
        
        switch family {
        case .systemSmall:
            UnsupportedView()
        case .systemMedium:
            MediumGalleryNFTView(list: list)
        case .systemLarge:
            LargeGalleryNFTView(list: list)
        case .systemExtraLarge:
            UnsupportedView()
        @unknown default:
            UnsupportedView()
        }
        
    }
}

struct MediumGalleryNFTView: View {
    let list: [GalleryNFTItem]
    
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
                        
                        HeadingLockup(
                            title: item.assetTitle ?? "Untitled",
                            text: nil,
                            size: 12
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
                        .padding(inset / 2)
                }
                Spacer()
            }
        }
    }
}


struct LargeGalleryNFTView: View {
    let list: [GalleryNFTItem]
    
    var body: some View {
        Text("TODO")
    }
}


//struct GalleryNFTRowView: View {}

struct GalleryNFTView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                GalleryNFTView(
                    list: Array(
                        repeating: .init(contractAddress: TestData.nft.address, tokenId: TestData.nft.tokenId, imageUrl: TestData.nft.imageUrl, assetTitle: TestData.nft.title, collectionTitle: TestData.nft.collection?.title, backgroundColor: nil),
                        count: 2
                    )
                )
            }.previewContext(
                WidgetPreviewContext(family: .systemMedium)
            )
            
            VStack{
                GalleryNFTView(
                    list: Array(
                        repeating: .init(contractAddress: TestData.nft.address, tokenId: TestData.nft.tokenId, imageUrl: TestData.nft.imageUrl, assetTitle: TestData.nft.title, collectionTitle: TestData.nft.collection?.title, backgroundColor: nil),
                        count: 6
                    )
                )
            }.previewContext(
                WidgetPreviewContext(family: .systemLarge)
            )
        }
    }
}
