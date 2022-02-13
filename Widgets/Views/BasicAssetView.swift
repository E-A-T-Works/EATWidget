//
//  AssetView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit


struct BasicAssetView: View {
    
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
            SmallBasicAssetView(
                contractAddress: contractAddress, tokenId: tokenId, imageUrl: imageUrl, assetTitle: assetTitle, collectionTitle: collectionTitle, backgroundColor: backgroundColor, displayInfo: displayInfo
            )
        case .systemMedium:
            UnsupportedView()
        case .systemLarge:
            LargeBasicAssetView(
                contractAddress: contractAddress, tokenId: tokenId, imageUrl: imageUrl, assetTitle: assetTitle, collectionTitle: collectionTitle, backgroundColor: backgroundColor, displayInfo: displayInfo
            )
        case .systemExtraLarge:
            UnsupportedView()
        @unknown default:
            UnsupportedView()
        }
    }
}



struct SmallBasicAssetView: View {
    
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
        VStack(alignment: .leading) {
            HStack(alignment: .top) {

                URLImage(url: imageUrl!)
                    .scaledToFit()
                    .background(Color(uiColor: backgroundColor ?? .clear))

                if displayInfo {
                    Spacer()
                    
                    Branding()
                        .frame(width: 30, height: 30)
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

struct MediumBasicAssetView: View {
    
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
        GeometryReader { geo in
         
            VStack(alignment: .leading) {
                ZStack {
                    Color(uiColor: backgroundColor ?? .clear)
                    URLImage(url: imageUrl!)
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height - (displayInfo ? 30 + 2 * 16.0 : 0))
                }
                
                if displayInfo {
                    HStack {
                        HeadingLockup(
                            title: assetTitle ?? tokenId,
                            text: collectionTitle,
                            size: 12
                        )

                        Spacer()
                    
                        Branding()
                            .frame(width: 30, height: 30)
                    }
                    .padding(16.0)
                }
            }
            
        }
    }
}

struct LargeBasicAssetView: View {
    
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
        GeometryReader { geo in
         
            VStack(alignment: .leading) {
                ZStack {
                    Color(uiColor: backgroundColor ?? .clear)
                    URLImage(url: imageUrl!)
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height - (displayInfo ? 30 + 2 * 16.0 : 0))
                }
                
                if displayInfo {
                    HStack {
                        HeadingLockup(
                            title: assetTitle ?? tokenId,
                            text: collectionTitle,
                            size: 12
                        )

                        Spacer()
                    
                        Branding()
                            .frame(width: 30, height: 30)
                    }
                    .padding(16.0)
                }
            }
            
        }
    }
}



struct BasicAssetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                BasicAssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageUrl: TestData.asset.imageUrl,
                    assetTitle: TestData.asset.title,
                    collectionTitle: TestData.asset.collection?.title,
                    backgroundColor: TestData.asset.backgroundColor,
                    displayInfo: false
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )

            VStack{
                BasicAssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageUrl: TestData.asset.imageUrl,
                    assetTitle: TestData.asset.title,
                    collectionTitle: TestData.asset.collection?.title,
                    backgroundColor: TestData.asset.backgroundColor,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
            
            
            VStack{
                BasicAssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageUrl: TestData.asset.imageUrl,
                    assetTitle: TestData.asset.title,
                    collectionTitle: TestData.asset.collection?.title,
                    backgroundColor: TestData.asset.backgroundColor,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemMedium)
            )

            VStack{
                BasicAssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageUrl: TestData.asset.imageUrl,
                    assetTitle: TestData.asset.title,
                    collectionTitle: TestData.asset.collection?.title,
                    backgroundColor: TestData.asset.backgroundColor,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemLarge)
            )
        }
    }
}


