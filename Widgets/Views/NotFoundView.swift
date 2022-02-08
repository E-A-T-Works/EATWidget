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
        Text("Not Found")
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
