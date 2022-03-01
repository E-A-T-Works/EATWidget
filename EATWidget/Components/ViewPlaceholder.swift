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
                .opacity(0.72)
                .padding(.vertical, 8)
        }
    }
}

struct ViewPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        ViewPlaceholder()
    }
}
