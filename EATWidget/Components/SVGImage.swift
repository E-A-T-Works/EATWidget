//
//  SVGImage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import SwiftUI
import PocketSVG

struct SVGImage: UIViewRepresentable {
    var url: URL
    var width: Int
    var height: Int
    
    func makeUIView(context: Context) -> UIView {
        let svgView = UIView(
            frame: CGRect(x: 0, y: 0, width: width, height: height)
        )
        
        let svgImageView = SVGImageView.init(contentsOf: url)
        
        svgImageView.frame = svgView.bounds
        svgImageView.contentMode = .scaleAspectFit
        
        svgView.addSubview(svgImageView)

        return svgView
    }
    
    func updateUIView(_ view: UIView, context: Context) { }
}

struct SVGImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SVGImage(
                url: URL(string: "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg")!,
                width: 400,
                height: 400
            ).frame(width: 400, height: 400, alignment: .center)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
