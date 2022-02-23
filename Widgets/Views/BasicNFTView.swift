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
    
    let address: String
    let tokenId: String
    let image: UIImage
    let title: String?
    let text: String?
    
    let displayInfo: Bool
    
    var inset: CGFloat {
        return displayInfo ? 16.0 : 0.0
    }
    
    // MARK: Content
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallBasicNFTView(
                address: address,
                tokenId: tokenId,
                image: image,
                title: title,
                text: text,
                displayInfo: displayInfo
            )
        case .systemMedium:
            MediumBasicNFTView(
                address: address,
                tokenId: tokenId,
                image: image,
                title: title,
                text: text
            )
        case .systemLarge:
            LargeBasicNFTView(
                address: address,
                tokenId: tokenId,
                image: image,
                title: title,
                text: text,
                displayInfo: displayInfo
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

    let address: String
    let tokenId: String
    let image: UIImage
    let title: String?
    let text: String?
    
    let displayInfo: Bool
    
    var inset: CGFloat {
        return displayInfo ? 16.0 : 0.0
    }
    
    // MARK: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {

                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                if displayInfo {
                    Spacer()
                    
                    Branding().frame(width: 24, height: 24)
                }
            }
            
            if displayInfo {
                Spacer()
                
                HStack {
                    HeadingLockup(
                        title: title,
                        text: text,
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

    let address: String
    let tokenId: String
    let image: UIImage
    let title: String?
    let text: String?
    
    
    // MARK: Content
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
                ZStack {

                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
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
                                title: title,
                                text: text,
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
    @Environment(\.colorScheme) var colorScheme
    
    
    // MARK: Parameters

    let address: String
    let tokenId: String
    let image: UIImage
    let title: String?
    let text: String?
    
    let displayInfo: Bool
    
    
    // MARK: Content
    
    var body: some View {
        ZStack {   
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)

            if displayInfo {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    
                    HStack {
                        HeadingLockup(
                            title: title,
                            text: text,
                            size: 12
                        )

                        Spacer()
                    
                        Branding()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.vertical, 16.0)
                    .padding(.horizontal, 24.0)
                    .background(colorScheme == .dark ? .black : .white)
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
                    address: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    image: TestData.nft.image,
                    title: TestData.nft.title,
                    text: nil,
                    displayInfo: false
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )

            VStack{
                BasicNFTView(
                    address: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    image: TestData.nft.image,
                    title: TestData.nft.title,
                    text: nil,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )


            VStack{
                BasicNFTView(
                    address: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    image: TestData.nft.image,
                    title: TestData.nft.title,
                    text: nil,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemMedium)
            )

            VStack{
                BasicNFTView(
                    address: TestData.nft.address,
                    tokenId: TestData.nft.tokenId,
                    image: TestData.nft.image,
                    title: TestData.nft.title,
                    text: nil,
                    displayInfo: true
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemLarge)
            )
        }
    }
}


