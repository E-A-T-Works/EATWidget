//
//  DiscordPrompt.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import SwiftUI

struct DiscordPrompt: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Link(destination: URL(string: "https://discord.gg/tmaddD9C")!) {
            
            HStack(alignment: .center) {
                Image(uiImage: UIImage(named: "Discord")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                Text("Thanks for testing out e.a.t. Join our Discord to have a direct impact on the project as it develops.")
                    .font(.system(size: 12.0, design: .monospaced))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Image(systemName: "arrow.up.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .opacity(0.32)
            }
            .padding()
            .background(colorScheme == .dark ? .white.opacity(0.12) : .black.opacity(0.04))
            .foregroundColor(colorScheme == .dark ? .white : .black)

        }
    }
}

struct DiscordPrompt_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DiscordPrompt()
        }

        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
