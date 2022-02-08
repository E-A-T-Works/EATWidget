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
        Text("Placeholder")
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
