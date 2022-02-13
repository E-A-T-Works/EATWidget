//
//  AssetSheetTraits.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import SwiftUI

struct AssetSheetTraits: View {
    
    let list: [Trait]
    
    let size: CGFloat = 124
    let spacing: CGFloat = 10
    
    var columns: [GridItem] {
        Array(repeating: .init(.fixed(size), spacing: spacing, alignment: .center), count: 3)
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            SectionTitle(text: "Traits")
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(list, id: \.self) { trait in
                    TraitBox(item: trait)
                        .frame(width: size, height: size, alignment: .center)
                }
            }
        }
    }
}

struct AssetSheetTraits_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetSheetTraits(
                list: TestData.asset.traits!
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
        
    }
}
