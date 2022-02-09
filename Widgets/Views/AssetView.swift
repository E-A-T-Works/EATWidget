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
    let backgroundColor: String?
    
    let displayInfo: Bool
    
    var body: some View {
        switch family {
        case .systemSmall:
            AssetView_Small(
                contractAddress: contractAddress,
                tokenId: tokenId,
                imageUrl: imageUrl,
                title: title,
                backgroundColor: backgroundColor,
                displayInfo: displayInfo
            )
        case .systemMedium:
            AssetView_Medium(
                contractAddress: contractAddress,
                tokenId: tokenId,
                imageUrl: imageUrl,
                title: title,
                backgroundColor: backgroundColor
            )
        case .systemLarge:
            AssetView_Large(
                contractAddress: contractAddress,
                tokenId: tokenId,
                imageUrl: imageUrl,
                title: title,
                backgroundColor: backgroundColor
            )
        case .systemExtraLarge:
            AssetView_Large(
                contractAddress: contractAddress,
                tokenId: tokenId,
                imageUrl: imageUrl,
                title: title,
                backgroundColor: backgroundColor
            )
        @unknown default:
            UnsupportedView()
        }
    }
}


// MARK: Small

struct AssetView_Small: View {

    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let title: String?
    let backgroundColor: String?
    
    let displayInfo: Bool
    
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                HexBackground(hexColor: backgroundColor)
                
                HStack {
                    VStack {
                        URLImageView(url: imageUrl!)
                            .scaledToFill()
                            .frame(
                                width: AssetView_Helpers.getImageSize(
                                    displayInfo: displayInfo,
                                    width: geo.size.width,
                                    height: geo.size.height
                                ),
                                height: AssetView_Helpers.getImageSize(
                                    displayInfo: displayInfo,
                                    width: geo.size.width,
                                    height: geo.size.height
                                )
                            )

                        Spacer()
                    }
                    Spacer()
                }
                .padding(displayInfo ? 8 : 0)
                
                if(displayInfo) {

                    HStack(alignment: .top) {
                        Spacer()
                        VStack {
                            Image(
                                uiImage: UIImage(named: "Icon_Black")!
                            )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .cornerRadius(12)
                            .padding([.top], 12)
                            .padding([.trailing], 8)
                            
                            Spacer()
                        }
                    }


                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Spacer()
                            VStack {
                                Text("\(title ?? "Untitled")")
                                    .font(.headline)
                                    .lineLimit(1)
                            }
                            .padding([.bottom], 12)
                            .padding([.leading, .trailing], 12)

                        }
                        Spacer()
                    }

                }

            }
        }
        
    }
}


// MARK: Medium

struct AssetView_Medium: View {
    
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let title: String?
    let backgroundColor: String?
    
    var body: some View {
        Text("Medium")
    }
}


// MARK: Large

struct AssetView_Large: View {
    
    let contractAddress: String
    let tokenId: String
    let imageUrl: URL?
    let title: String?
    let backgroundColor: String?
    
    var body: some View {
        Text("Large")
    }
}


// MARK: Helpers

final class AssetView_Helpers {
    static func getScaleFactor(displayInfo: Bool) -> Double {
        return displayInfo ? 0.72 : 1.0
    }
    
    static func getImageSize(displayInfo: Bool, width: Double, height: Double) -> Double {
        let scaleFactor = getScaleFactor(displayInfo: displayInfo)
        let size = width > height ? width : height
        
        return size * scaleFactor
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


