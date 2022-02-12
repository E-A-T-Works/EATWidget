//
//  HeadingLockup.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct HeadingLockup: View {
    let title: String?
    let text: String?
    
    let fontStyle: Font.TextStyle
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title ?? "Untitled")
                .font(.system(fontStyle, design: .monospaced))
                .fontWeight(.black)
                .lineLimit(1)
            
            if text != nil {
                Text(text!)
                    .font(.system(fontStyle, design: .monospaced))
                    .fontWeight(.light)
                    .lineLimit(1)
            }
        }
    }
}

struct HeadingLockup_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            HeadingLockup(
                title: TestData.asset.title,
                text: TestData.asset.collection?.title,
                fontStyle: .caption
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
        
    }
}