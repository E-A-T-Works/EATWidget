//
//  Branding.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct Branding: View {
    @Environment(\.colorScheme) var colorScheme
    
    var seed: Int = 0
    
    init(seed: Int = 0) {
        if seed < 0 || seed > 6 {
            self.seed = Int.random(in: 0..<7)
        } else {
            self.seed = seed
        }
    }

    var body: some View {
        ZStack{
            Image(
                uiImage: UIImage(
                    named: colorScheme == .dark ? "eat-w-b-\(String(format: "%02d", seed))" : "eat-b-w-\(String(format: "%02d", seed))"
                )!
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
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
