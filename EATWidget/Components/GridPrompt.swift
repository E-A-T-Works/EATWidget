//
//  GridPrompt.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import SwiftUI

struct GridPrompt: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Oh hey, nice art! Some of these would look beautiful on your home screen. Let us show you how...")
                .font(.system(size: 12.0, design: .monospaced))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "arrow.up.right")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12, alignment: .center)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .opacity(0.32)
        }
        .padding(.vertical)
        .padding(.horizontal, 10)
        .background(colorScheme == .dark ? .white.opacity(0.12) : .black.opacity(0.04))
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

struct GridPrompt_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GridPrompt()
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
