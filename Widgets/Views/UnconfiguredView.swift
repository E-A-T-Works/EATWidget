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
        VStack{
            Branding().frame(width: 40, height: 40, alignment: .center)
            Text("Widget is not setup")
                .font(.system(size: 12, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding()
        }
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
