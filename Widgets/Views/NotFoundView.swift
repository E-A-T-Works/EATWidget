//
//  NotFoundView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct NotFoundView: View {
    var body: some View {
        VStack{
            Branding().frame(width: 40, height: 40, alignment: .center)
            Text("Trouble loading NFT")
                .font(.system(size: 12, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct NotFoundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                NotFoundView()
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
