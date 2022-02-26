//
//  WebView.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/25/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var html: String
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.loadHTMLString(html, baseURL: nil)
        
        return view
    }
     
    func updateUIView(_ uiView: WKWebView, context: Context) {
      uiView.loadHTMLString(html, baseURL: nil)
    }
}


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WebView(html: "<p>Hello World</p>")
        }
        .frame(width: 100, height: 100)
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
