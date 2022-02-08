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
        Text("Unsupported")
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
