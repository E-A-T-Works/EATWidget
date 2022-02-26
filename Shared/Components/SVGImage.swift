//
//  SVGImage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/25/22.
//

import PocketSVG
import SwiftUI

struct SVGImage: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let svgView = UIView(frame: UIScreen.main.bounds)
        
        let url = Bundle.main.url(forResource: "everyicon-test", withExtension: "svg")!
                
        let svgImageView = SVGImageView.init(contentsOf: url)
        svgImageView.frame = svgView.bounds
        svgImageView.contentMode = .scaleAspectFit
        svgView.addSubview(svgImageView)

        return svgView
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

struct SVGImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SVGImage()
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
