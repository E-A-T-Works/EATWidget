//
//  UnsupportedView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct UnsupportedView: View {
    var body: some View {
        VStack{
            Branding().frame(width: 40, height: 40, alignment: .center)
            Text("Unsupported NFT")
                .font(.system(size: 12, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct UnsupportedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                UnsupportedView()
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
