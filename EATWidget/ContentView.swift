//
//  ContentView.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI
import PocketSVG

struct ContentView: View {
    var body: some View {
        NavigationView {
            CollectionPage()
        }
        .navigationViewStyle(.stack)
        
//        Text("HI").onAppear {
//            print("HI THERE")
//            
//            DispatchQueue.global(qos: .background).async {
//                let url = Bundle.main.url(forResource: "everyicon-test", withExtension: "svg")!
//                let frame = CGRect(x: 0, y: 0, width: 512, height: 512)
//                let svgLayer = SVGLayer(contentsOf: url)
//                svgLayer.frame = frame
//
//                let image = self.snapshotImage(for: svgLayer)
//
//                
//                print(image)
//                
//                print(image?.size)
//                
//                print(image?.jpegData(compressionQuality: 1))
//                
////                DispatchQueue.main.async {
////                    imageView.image = image
////                }
//            }
            
//        }
//        VStack {
//            SVGImageView(contentsOf: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/30/Vector-based_example.svg")!)
//        }
    }
    
    private func snapshotImage(for layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
