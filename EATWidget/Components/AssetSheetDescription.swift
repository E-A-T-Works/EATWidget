//
//  AssetSheetDescription.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct AssetSheetDescription: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.system(size: 14, design: .monospaced))
                .fontWeight(.light)
        }
    }
}

struct AssetSheetDescription_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetSheetDescription(
                text: "Hello world how are you?"
            )
        }
        .frame(width: 280, height: 200)
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
