//
//  CreatorItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CreatorItem: View {
    
    let title: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 12.0, design: .monospaced))
                    .fontWeight(.black)
                    .lineSpacing(1.5)
            }
            
            Spacer()
        }
    }
}

struct CreatorItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CreatorItem(title: "Someone Awesome")
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
