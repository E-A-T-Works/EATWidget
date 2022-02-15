//
//  PlaceholderView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct PlaceholderView: View {
    var body: some View {
        VStack{
            Branding().frame(width: 40, height: 40, alignment: .center)
            Text("e·a·t")
                .font(.system(size: 12, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                PlaceholderView()
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
