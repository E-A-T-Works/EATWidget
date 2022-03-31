//
//  AttributeGrid.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import SwiftUI

struct AttributeGrid: View {
    
    let list: [CachedAttribute]
    
    private var gridItemLayout = [
        GridItem(.adaptive(minimum: 150, maximum: 200)),
        GridItem(.adaptive(minimum: 150, maximum: 200)),
        GridItem(.adaptive(minimum: 150, maximum: 200)),
    ]
    
    init(list: [CachedAttribute]) {
        self.list = list
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            SectionTitle(text: "Attributes")

            LazyVGrid(columns: gridItemLayout, spacing: 10) {
                ForEach(list, id: \.self) { item in
                    AttributeBox(item: item)
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
