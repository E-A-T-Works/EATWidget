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
//        let metaTagModifier = "var meta = document.createElement('meta'); meta.setAttribute('http-equiv', 'Content-Security-Policy'); meta.setAttribute('content', 'default-src 'self'; img-src https://*; child-src 'none';'); document.getElementsByTagName('head')[0].appendChild(meta);"
//
//        let script = WKUserScript(source: metaTagModifier, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//
//        let controller = WKUserContentController()
//        controller.addUserScript(script)
//
//        let config = WKWebViewConfiguration()
//        config.userContentController = controller
//
//        let view = WKWebView(frame: CGRect.zero, configuration: config)
        
        let view = WKWebView(frame: CGRect.zero)
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
