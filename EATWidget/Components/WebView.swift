//
//  WebView.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/25/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
//        view.loadHTMLString(html, baseURL: nil)
        view.load(URLRequest.init(url: url))
        
        return view
    }
     
    func updateUIView(_ uiView: WKWebView, context: Context) {
//      uiView.loadHTMLString(html, baseURL: nil)
    }
}


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WebView(
                url: URL(string: "https://everyicon.xyz/icon/?tokenId=40")!
            )
        }
        .frame(width: 100, height: 100)
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
