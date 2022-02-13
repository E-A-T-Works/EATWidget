//
//  SectionTitle.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import SwiftUI

struct SectionTitle: View {
    
    let text: String
    
    var body: some View {
        HStack{
            Text(text)
                .font(.system(size: 14, design: .monospaced))
                .fontWeight(.black)
        }
        .padding(.bottom, 2)
        
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            SectionTitle(text: "Title")
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
    
    
}

