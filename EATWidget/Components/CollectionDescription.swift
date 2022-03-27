//
//  CollectionDescription.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import SwiftUI

struct CollectionDescription: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.system(size: 12.0, design: .monospaced))
                .lineSpacing(1.5)
        }
    }
}

struct CollectionDescription_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionDescription(
                text: "A re-imagining of Every Icon, John F. Simon Jr.'s seminal web-based software art work first released in 1997.  This blockchain-native, on-chain expression was created by John F. Simon Jr. and divergence, in collaboration with FingerprintsDAO and e•a•t•}works"
            )
        }.previewLayout(PreviewLayout.sizeThatFits)
    }
}
