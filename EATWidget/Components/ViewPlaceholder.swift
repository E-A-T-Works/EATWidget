//
//  ViewPlaceholder.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import SwiftUI

struct ViewPlaceholder: View {
    var text: String = "Nothing to see here..."
    
    var body: some View {
        VStack {
            Text(text)
                .font(.system(size: 12, design: .monospaced))
                .multilineTextAlignment(.center)
                .opacity(0.72)
                .padding(.vertical, 8)
                .frame(maxWidth: 300)
        }
    }
}

struct ViewPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        ViewPlaceholder(text: "Sorry, we don't support any of these NFTs yet.")
    }
}
