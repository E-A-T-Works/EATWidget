//
//  SVGImage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/25/22.
//

import SwiftUI
import Macaw


struct SVGImage: UIViewRepresentable {
    // a binding allows for dynamic updates to the shown image
    @Binding var name: String

    init(name: Binding<String>) {
        _name = name
    }

    // convenience constructor to allow for a constant image name
    init(name: String) {
        _name = .constant(name)
    }

    func makeUIView(context: Context) -> SVGView {
        let svgView = SVGView()
        svgView.backgroundColor = .clear
        svgView.contentMode = .scaleAspectFit
        
        return svgView
    }

    func updateUIView(_ uiView: SVGView, context: Context) {
        uiView.fileName = name
    }
}

struct SVGImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            SVGImage(
                name: "everyicon-test"
            )
        }
        .frame(width: 512, height: 512)
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
