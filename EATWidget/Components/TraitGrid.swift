//
//  TraitGrid.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import SwiftUI

struct TraitGrid: View {
    
    let list: [NFTAttribute]
    
    let size: CGFloat = 120
    let spacing: CGFloat = 10
    
    

    
    var body: some View {
        
        VStack(alignment: .leading) {
            SectionTitle(text: "Traits")
            
            LazyVGrid(
                columns: Array(
                    repeating: .init(
                        .fixed(size), spacing: spacing, alignment: .center
                    ), count: 3
                ),
                spacing: spacing
            ) {
                ForEach(list, id: \.self) { trait in
                    TraitBox(item: trait)
                        .frame(width: size, height: size, alignment: .center)
                }
            }
        }
    }
}

struct TraitGrid_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TraitGrid(
                list: []
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
        
    }
}
