//
//  Branding.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct Branding: View {
    @Environment(\.colorScheme) var colorScheme
    @State var seed: Int = 0
    
    let randomize: Bool = true

    var body: some View {
        ZStack{
            Image(
                uiImage: UIImage(
                    named: colorScheme == .dark ? "eat-w-b-\(seed)" : "eat-b-w-\(seed)"
                )!
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
        }.onAppear {
            if !randomize {
                return
            }
            seed = Int.random(in: 0..<7)
        }
    }
}

struct Branding_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Branding(seed: 0)
                .frame(width: 64, height: 64)
                .padding()
        }
        .previewLayout(PreviewLayout.sizeThatFits)
            
    }
}
