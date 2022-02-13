//
//  TableItem.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct TableItem: View {
    
    let key: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(key):")
                .font(.system(size: 14, design: .monospaced))
                .fontWeight(.bold)
                .lineLimit(1)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, design: .monospaced))
                .fontWeight(.light)
                .lineLimit(1)
        }
    }
}

struct TableItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            TableItem(
                key: "Foo",
                value: "Bar"
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
