//
//  UnconfiguredView.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct UnconfiguredView: View {
    var body: some View {
        Text("Unconfigured")
    }
}

struct UnconfiguredView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack{
                UnconfiguredView()
            }
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
        }
    }
}
