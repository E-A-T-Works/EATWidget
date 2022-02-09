//
//  HexBackground.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit

struct HexBackground: View {
    
    let hexColor: String?
    
    var body: some View {
        if hexColor != nil {
            Color(uiColor: UIColor(hexString: hexColor!)!)
        } else {
            Color.clear
        }
    }
}

struct HexBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                HexBackground(hexColor: "FF0000")
            }
            .previewContext(
                WidgetPreviewContext(family: .systemLarge)
            )
            
            VStack {
                HexBackground(hexColor: nil)
            }
            .previewContext(
                WidgetPreviewContext(family: .systemLarge)
            )
        }
        
    }
}

