//
//  URLImage.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct URLImage: View {
    let url: URL

    var body: some View {
        // TODO: This causes a memory leak
        if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
        }
    }
}

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                URLImage(
                    url: URL(string: "https://nfts.superplastic.co/images/3372.png")!
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
