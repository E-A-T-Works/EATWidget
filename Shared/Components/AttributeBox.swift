//
//  AttributeBox.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import SwiftUI

struct AttributeBox: View {
    let key: String?
    let value: String?
    
    var body: some View {
        
        VStack {
            Text(key ?? "--")
                .font(.system(size: 10, design: .monospaced))
                .fontWeight(.bold)
                .lineLimit(1)
                .padding(.bottom, 1)
            
            Text(value ?? "--")
                .font(.system(size: 10, design: .monospaced))
                .fontWeight(.light)
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(.thickMaterial)

    }
}

struct AttributeBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AttributeBox(
                key: "Foo",
                value: "Bar"
            ).frame(width: 100, height: 100)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
    }
}
