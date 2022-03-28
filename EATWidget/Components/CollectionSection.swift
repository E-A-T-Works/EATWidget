//
//  CollectionSection.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CollectionSection: View {
    let item: Collection
    
    var body: some View {
        VStack {
            CollectionVisual(url: item.banner)
                .frame(height: 150)
            
            VStack {
                CollectionHeader(title: item.title, address: item.address)
                    .padding(.bottom)
            
                CreatorItem(title: "John Simon Jr")
                    .padding(.bottom)
                
                if item.text != nil {
                    CollectionDescription(text: item.text!)
                        .padding(.bottom)
                }
                
                if item.links.count > 0 {
                    ActionRow(list: [])
                        .padding(.vertical)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct CollectionSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionSection(item: TestData.collection)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
    }
}
