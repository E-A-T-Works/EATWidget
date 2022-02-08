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
    
    private func getScaleFactor() -> Double {
        return displayInfo ? 0.72 : 1.0
    }
    
    private func getImageSize(width: Double, height: Double) -> Double {
        let scaleFactor = getScaleFactor()
        let size = width > height ? width : height
        
        return size * scaleFactor
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HexBackground(hexColor: backgroundColor)
                
                HStack {
                    VStack {
                        URLImageView(url: imageUrl!)
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
                            .frame(width: 24, height: 24)
                            .cornerRadius(12)
                            .padding(8)
                            
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
                            .padding(8)

                        }
                        Spacer()
                    }

                }

            }
        }
    }
}

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
        }
    }
}
