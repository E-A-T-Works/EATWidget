//
//  URLButton.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

enum URLButtonSize {
    case Small
    case Normal
    case Large
}

struct URLButton: View {
    @Environment(\.colorScheme) var colorScheme

    let url: URL
    let image: UIImage
    let title: String?
    
    let size: URLButtonSize = .Normal
    
    var body: some View {
        Link(
            destination: url,
            label: {
                HStack{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height:  18)
                    
                    if title != nil {
                        Text(title!)
                            .font(.system(size: 12, design: .monospaced))
                            .lineLimit(1)
                            .foregroundColor(
                                colorScheme == .dark ? Color.white : Color.black
                            )
                    }
                }
            }
        )
//        .buttonStyle(.bordered)
        .padding(.horizontal, 6)
    }
}

struct URLButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            URLButton(
                url: URL(string: "https://eatworks.xyz")!,
                image: UIImage(systemName: "safari")!,
                title: "Button"
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
