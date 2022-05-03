//
//  TestSVGView.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 5/3/22.
//

import SwiftUI
import SVGKit

struct SVGView:UIViewRepresentable
{
    @Binding var url:URL
    @Binding var size:CGSize
    
    func makeUIView(context: Context) -> SVGKFastImageView {
        let svgImage = SVGKImage(contentsOf: url)
        return SVGKFastImageView(svgkImage: svgImage ?? SVGKImage())
        
    }
    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        uiView.image = SVGKImage(contentsOf: url)
        
        uiView.image.size = size
    }
    
    
}

struct SVGImage_Previews: PreviewProvider {
    static var previews: some View {
        SVGView(
            url: .constant(URL(string:"https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg")!),
            size: .constant(CGSize(width: 100,height: 100))
        ).frame(width: 100, height: 100)
    }
}
