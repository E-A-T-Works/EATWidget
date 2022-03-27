//
//  CollectionSegment.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CollectionSegment: View {
    let item: Collection
    
    var body: some View {
        VStack {
            CollectionVisual(
                url: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2F0xf9a423b86afbf8db41d7f24fa56848f56684e43f%2Fbanner.png?alt=media&token=e6f96e72-067e-4c02-bcbe-c5f0d0288e20")!
            )
            
            VStack {
                CollectionHeader(
                    title: "Every Icon",
                    address: "0x000000000000000000"
                )
                .padding(.bottom)
            
                CreatorItem(title: "John Simon Jr")
                    .padding(.bottom)
                    
                CollectionDescription(
                    text: "A re-imagining of Every Icon, John F. Simon Jr.'s seminal web-based software art work first released in 1997.  This blockchain-native, on-chain expression was created by John F. Simon Jr. and divergence, in collaboration with FingerprintsDAO and e•a•t•}works"
                )
                .padding(.bottom)
                
                ActionRow(
                    list: [
                        ActionRowButton(target: .Other, url: URL(string: "https://google.com")!),
                        ActionRowButton(target: .Discord, url: URL(string: "https://google.com")!),
                        ActionRowButton(target: .Twitter, url: URL(string: "https://google.com")!),
                        ActionRowButton(target: .Etherscan, url: URL(string: "https://google.com")!)
                    ]
                )
                .padding(.vertical)
                
            }
            .padding(.horizontal)
        }
    }
}

struct CollectionSegment_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionSegment(item: TestData.collection)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
    }
}
