//
//  AttributeGrid.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import SwiftUI

struct AttributeGrid: View {
    
    let list: [CachedAttribute]
    
    let size: CGFloat = 120
    let spacing: CGFloat = 10
    
    var body: some View {
        
        VStack(alignment: .leading) {
            SectionTitle(text: "Attributes")
            
            LazyVGrid(
                columns: Array(
                    repeating: .init(
                        .fixed(size), spacing: spacing, alignment: .center
                    ), count: 3
                ),
                spacing: spacing
            ) {
                ForEach(list, id: \.self) { item in
                    AttributeBox(item: item)
                        .frame(width: size, height: size, alignment: .center)
                }
            }
        }
    }
}

struct AttributeGrid_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AttributeGrid(
                list: []
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
        
    }
}
