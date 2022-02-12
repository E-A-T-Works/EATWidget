//
//  AssetView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit


struct AssetView: View {
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let title: String?
    let backgroundColor: UIColor?
    
    let displayInfo: Bool
    
    var body: some View {
        switch family {
        case .systemSmall:
            AssetViewContent(
                contractAddress: contractAddress,
                tokenId: tokenId,
                imageUrl: imageUrl,
                title: title,
                backgroundColor: backgroundColor,
                displayInfo: displayInfo,
                scaleFactor: 0.72,
                inset: 8,
                fontStyle: .callout
            )
            
        case .systemMedium:
            Text("TODO")
            
        case .systemLarge, .systemExtraLarge:
            AssetViewContent(
                contractAddress: contractAddress,
                tokenId: tokenId,
                imageUrl: imageUrl,
                title: title,
                backgroundColor: backgroundColor,
                displayInfo: displayInfo,
                scaleFactor: 0.80,
                inset: 12,
                fontStyle: .title2
            )
        @unknown default:
            UnsupportedView()
        }
    }
}


// MARK: Generic Asset Widget View

struct AssetViewContent: View {
    
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let title: String?
    let backgroundColor: UIColor?
    
    let displayInfo: Bool
    
    let scaleFactor: CGFloat
    let inset: CGFloat
    let fontStyle: Font.TextStyle
    
    
    private func getImageSize(width: CGFloat, height: CGFloat) -> CGFloat {
        let size = width > height ? width : height
        return displayInfo ? size * scaleFactor : size
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(uiColor: backgroundColor ?? UIColor.clear)
                
                HStack {
                    VStack {
                        URLImage(url: imageUrl!)
                            .scaledToFill()
                            .frame(
                                width: getImageSize(
                                    width: geo.size.width,
                                    height: geo.size.height
                                ),
                                height: getImageSize(
                                    width: geo.size.width,
                                    height: geo.size.height
                                )
                            )
//                            .background(.white)
//                            .shadow(radius: 12)
                            .cornerRadius(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(.black.opacity(0.1), lineWidth: 1)
//                            )

                        Spacer()
                    }
                    Spacer()
                }
                .padding(displayInfo ? inset : 0)
                
                if(displayInfo) {

                    HStack(alignment: .top) {
                        Spacer()
                        VStack {
                            Branding()
                                .frame(width: 40, height: 40)
                                .padding(.top, inset)
                            
                            Spacer()
                        }
                    }
                    
                    HStack(alignment: .bottom) {
                        VStack {
                            Spacer()
                            HeadingLockup(
                                title: title,
                                text: nil,
                                fontStyle: fontStyle
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, inset)
                        
                        Spacer()
                    }

                }

            }
        }
    }
}




// MARK: Preview

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                AssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageUrl: TestData.asset.imageUrl,
                    title: TestData.asset.title,
                    backgroundColor: TestData.asset.backgroundColor,
                    displayInfo: false
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
            
            
            VStack{
                AssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageUrl: TestData.asset.imageUrl,
                    title: TestData.asset.title,
                    backgroundColor: TestData.asset.backgroundColor,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
            
            VStack{
                AssetView(
                    contractAddress: TestData.asset.contract.address,
                    tokenId: TestData.asset.tokenId,
                    imageUrl: TestData.asset.imageUrl,
                    title: TestData.asset.title,
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


