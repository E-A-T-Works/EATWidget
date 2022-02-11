//
//  Branding.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct Branding: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            Image(
                uiImage: UIImage(
                    named: colorScheme == .dark ? "Icon_White" : "Icon_Black"
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
            Branding()
                .frame(width: 64, height: 64)
                .padding()
        }
        .previewLayout(PreviewLayout.sizeThatFits)
            
    }
}
