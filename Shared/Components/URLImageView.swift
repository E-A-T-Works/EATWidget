//
//  URLImageView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct URLImageView: View {
    let url: URL

    var body: some View {
        if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "photo")
        }
    }
}

struct URLImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                URLImageView(
                    url: URL(string: "https://lh3.googleusercontent.com/rVIk8-4HlQBMZBY6ZqWTiS2C3o35c8dckAua22XCoaveyOAOdpQJCyrh93ugKElLPSfTOnHZ838hYu2cjkRoWM8e")!
                )
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}