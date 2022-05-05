//
//  TestSVGView.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 5/3/22.
//

//import SwiftUI
//import SVGKit
//
//struct SVGView:UIViewRepresentable
//{
//    @Binding var url:URL
//    @Binding var size:CGSize
//    
//    func makeUIView(context: Context) -> SVGKFastImageView {
//        let svgImage = SVGKImage(contentsOf: url)
//        return SVGKFastImageView(svgkImage: svgImage ?? SVGKImage())
//        
//    }
//    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
//        uiView.image = SVGKImage(contentsOf: url)
//        
//        uiView.image.size = size
//    }
//}
//
//struct SVGImage_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            
//            SVGView(
//                url: .constant(
//                    URL(string: "https://openseauserdata.com/files/e80cb036156c095dddb9b92899610039.svg")!
//                ),
//                size: .constant(
//                    CGSize(width: 100, height: 100)
//                )
//            ).frame(width: 100, height: 100)
//            
//        }
//        .padding()
//        .background(.red)
//        .previewLayout(PreviewLayout.sizeThatFits)
//        
//    }
//}
