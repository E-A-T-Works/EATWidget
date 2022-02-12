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
    
    // MARK: Content
    
    var body: some View {
      
        GeometryReader { geo in
            ZStack {
                Color(uiColor: backgroundColor ?? .clear)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        URLImage(url: imageUrl!)
                            .scaledToFill()
                            .frame(maxWidth: .infinity)

                        if displayInfo {
                            Spacer()
                            
                            Branding()
                                .frame(maxWidth: .infinity)
                        }
                        
                    }
                    
                    if displayInfo {
                        Spacer()
                        
                        HeadingLockup(
                            title: assetTitle ?? tokenId,
                            text: collectionTitle,
                            fontStyle: determineTextStyle()
                        )
                    }
                   
                }
                .padding(determineInset())
            }
        }
        
    }
    
    // MARK: Helpers
   
    private func determineInset() -> CGFloat {
        switch family {
        case .systemSmall:
            return displayInfo ? 10 : 0.0
        case .systemMedium:
            return displayInfo ? 10 : 0.0
        case .systemLarge:
            return displayInfo ? 12 : 0.0
        case .systemExtraLarge:
            return displayInfo ? 12 : 0.0
        
        @unknown default:
            return 0.0
        }
    }
    
    private func determineTextStyle() ->  Font.TextStyle {
        switch family {
        case .systemSmall:
            return .caption
        case .systemMedium:
            return .caption
        case .systemLarge:
            return .title3
        case .systemExtraLarge:
            return .title3
        
        @unknown default:
            return .caption
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
                WidgetPreviewContext(family: .systemLarge)
            )
        }
    }
}


