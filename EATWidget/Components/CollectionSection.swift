//
//  CollectionSection.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CollectionSection: View {
    let item: CachedCollection
    
    var body: some View {
        VStack {
            CollectionVisual(url: URL(string: "https://lh3.googleusercontent.com/KaKIl7YZumshMrV8BBNgj3TblOEmms1O0hMd4EfRcHykOvZFGZ3kw4XdNuPP3nNhxVnouBbB_riHTpbIl7CP_2HWeXnxwifacIQW7rU=h600")!)
                .frame(height: 150)
            
            VStack {
                CollectionHeader(title: item.title!, address: item.address!)
                    .padding(.bottom)
            
                CreatorItem(title: "John F. Simon Jr.")
                    .padding(.bottom)
                
                if item.text != nil {
                    CollectionDescription(text: item.text!)
                        .padding(.bottom)
                }
                
//                if item.links.count > 0 {
//                    ActionRow(list: [])
//                        .padding(.vertical)
//                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct CollectionSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            CollectionSection(item: TestData.collection)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
    }
}
