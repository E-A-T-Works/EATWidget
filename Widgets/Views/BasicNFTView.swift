//
//  NFTView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit


struct BasicNFTView: View {
    
    // MARK: Parameters

    @Environment(\.widgetFamily) var family: WidgetFamily
    
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let assetTitle: String?
    let collectionTitle: String?
    let backgroundColor: UIColor?
    
    let displayInfo: Bool
    
    var inset: CGFloat {
        return displayInfo ? 16.0 : 0.0
    }
    
    // MARK: Content
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallBasicNFTView(
                contractAddress: contractAddress, tokenId: tokenId, imageUrl: imageUrl, assetTitle: assetTitle, collectionTitle: collectionTitle, backgroundColor: backgroundColor, displayInfo: displayInfo
            )
        case .systemMedium:
            MediumBasicNFTView(
                contractAddress: contractAddress, tokenId: tokenId, imageUrl: imageUrl, assetTitle: assetTitle, collectionTitle: collectionTitle, backgroundColor: backgroundColor
            )
        case .systemLarge:
            LargeBasicNFTView(
                contractAddress: contractAddress, tokenId: tokenId, imageUrl: imageUrl, assetTitle: assetTitle, collectionTitle: collectionTitle, backgroundColor: backgroundColor, displayInfo: displayInfo
            )
        case .systemExtraLarge:
            UnsupportedView()
        @unknown default:
            UnsupportedView()
        }
    }
}



struct SmallBasicNFTView: View {
    
    // MARK: Parameters

    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let assetTitle: String?
    let collectionTitle: String?
    let backgroundColor: UIColor?
    
    let displayInfo: Bool
    
    var inset: CGFloat {
        return displayInfo ? 16.0 : 0.0
    }
    
    // MARK: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {

                URLImage(url: imageUrl!)
                    .scaledToFit()
                    .background(Color(uiColor: backgroundColor ?? .clear))

                if displayInfo {
                    Spacer()
                    
                    Branding().frame(width: 24, height: 24)
                }
            }
            
            if displayInfo {
                Spacer()
                
                HStack {
                    HeadingLockup(
                        title: assetTitle ?? tokenId,
                        text: collectionTitle,
                        size: 12
                    )

                    Spacer()
                    
                }
            }
           
        }
        .padding(inset)
    }
}

struct MediumBasicNFTView: View {
    
    // MARK: Parameters

    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let assetTitle: String?
    let collectionTitle: String?
    let backgroundColor: UIColor?
    
    
    // MARK: Content
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
                ZStack {
                    Color(uiColor: backgroundColor ?? .clear)
                    URLImage(url: imageUrl!)
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.5, height: geo.size.height)
                }
                
                ZStack {
                
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack {
                            Spacer()
                         
                            Branding().frame(width: 24, height: 24)
                        }

                        Spacer()
                    }

                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        HStack(spacing: 0) {
                            HeadingLockup(
                                title: assetTitle ?? tokenId,
                                text: collectionTitle,
                                size: 12
                            )
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
            }
        }
    }
}

struct LargeBasicNFTView: View {
    
    // MARK: Parameters

    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let assetTitle: String?
    let collectionTitle: String?
    let backgroundColor: UIColor?
    
    let displayInfo: Bool
    
    
    // MARK: Content
    
    var body: some View {
        ZStack {
            ZStack {
                Color(uiColor: backgroundColor ?? .clear)
                ZStack{
                    URLImage(url: imageUrl!)
                        .aspectRatio(1, contentMode: .fill)
                }
            }
            
            if displayInfo {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    
                    HStack {
                        HeadingLockup(
                            title: assetTitle ?? tokenId,
                            text: collectionTitle,
                            size: 12
                        )

                        Spacer()
                    
                        Branding()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.vertical, 16.0)
                    .padding(.horizontal, 24.0)
                    .background(.white)
                }
            }
        }
    }
}



struct BasicNFTView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                BasicNFTView(
                    contractAddress: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    imageUrl: TestData.nft.imageUrl,
                    assetTitle: TestData.nft.title,
                    collectionTitle: TestData.nft.collection?.title,
                    backgroundColor: nil,
                    displayInfo: false
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )

            VStack{
                BasicNFTView(
                    contractAddress: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    imageUrl: TestData.nft.imageUrl,
                    assetTitle: TestData.nft.title,
                    collectionTitle: TestData.nft.collection?.title,
                    backgroundColor: nil,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
            
            
            VStack{
                BasicNFTView(
                    contractAddress: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    imageUrl: TestData.nft.imageUrl,
                    assetTitle: TestData.nft.title,
                    collectionTitle: TestData.nft.collection?.title,
                    backgroundColor: nil,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemMedium)
            )

            VStack{
                BasicNFTView(
                    contractAddress: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    imageUrl: TestData.nft.imageUrl,
                    assetTitle: TestData.nft.title,
                    collectionTitle: TestData.nft.collection?.title,
                    backgroundColor: nil,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemLarge)
            )
        }
    }
}


