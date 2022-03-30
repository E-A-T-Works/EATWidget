//
//  ViewLoader.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI

struct ViewLoader: View {
    
    var seed: Int = 0
    var text: String? = "Loading..."
    
    init(seed: Int = 0) {
        if seed < 0 || seed > 5 {
            self.seed = Int.random(in: 0..<6)
        } else {
            self.seed = seed
        }
    }

    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .center) {
                LottieView(name: "spinner-\(String(format: "%02d", seed))", loopMode: .loop)
                    .frame(width: 80, height: 80)
                
                if text != nil && !text!.isEmpty {
                    Text("Loading...")
                        .font(.system(size: 12, design: .monospaced))
                        .opacity(0.72)
                        .padding(.vertical, 8)
                }
                
            }
            
            Spacer()
        }
        
    }
}

struct ViewLoader_Previews: PreviewProvider {
    static var previews: some View {
        ViewLoader()
    }
}
