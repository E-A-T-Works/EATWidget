//
//  URLLink.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct URLLink: View {
    
    let url: URL
    let title: String
    
    var body: some View {
        Link(
            destination: url,
            label: {
                HStack{

                    Text(title)
                        .font(.system(size: 14, design: .monospaced))
                        .lineLimit(1)
                        
                    Image(uiImage: UIImage(systemName: "arrow.up.right")!)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                        .frame(width: 8, height: 8)
                }
            }
        )
    }
}

struct URLLink_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            URLLink(
                url: URL(string: "https://google.com")!,
                title: "Link"
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
        
    }
}
