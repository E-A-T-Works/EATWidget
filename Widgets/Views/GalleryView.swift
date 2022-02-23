//
//  GalleryView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI
import WidgetKit


struct GalleryItem {
    let address: String
    let tokenId: String
    let image: UIImage
    let title: String?
    let text: String?
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
        if(list.count == 1) {
            MediumBasicNFTView(
                address: list.first!.address,
                tokenId: list.first!.tokenId,
                image: list.first!.image,
                title: list.first!.title,
                text: list.first!.text
            )
        } else if(list.count == 2) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(list, id: \.tokenId) { item in
                    VStack(spacing: 0) {
                        SmallBasicNFTView(
                            address: item.address,
                            tokenId: item.tokenId,
                            image: item.image,
                            title: item.title,
                            text: item.text,
                            displayInfo: false
                        )
                        .padding()
                    }
                }
            }

        } else {
            ZStack {
                HStack {
                    ForEach(list, id: \.tokenId) { item in
                        VStack {
                            SmallBasicNFTView(
                                address: item.address,
                                tokenId: item.tokenId,
                                image: item.image,
                                title: item.title,
                                text: item.text,
                                displayInfo: false
                            )
                        }
                    }
                }
                .padding(inset)
//                .padding(.horizontal, inset)
//                .padding(.top, 24)
//                .padding(.bottom, 0)
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
                        repeating: .init(
                            address: TestData.nft.address,
                            tokenId: TestData.nft.tokenId,
                            image: TestData.nft.image,
                            title: TestData.nft.title,
                            text: TestData.nft.text
                        ),
                        count: 4
                    )
                )
            }.previewContext(
                WidgetPreviewContext(family: .systemMedium)
            )

        }
    }
}
