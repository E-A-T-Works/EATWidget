//
//  OverlaySpinner.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import SwiftUI

struct OverlaySpinner: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.04)
            
            VStack {
                Spacer()
                
                ZStack {
                    Color.white
                        .shadow(color: .black, radius: 4, x: 0, y: 2)
                    
                    HStack {
                        
                        LottieView(name: "spinner-00", loopMode: .loop)
                            .frame(width: 80, height: 80)
                        
                        Text("One moment...")
                        
                        Spacer()
                            
                    }
                }
                .frame(width: 224, height: 64)
                .cornerRadius(12)
                
                
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct OverlaySpinner_Previews: PreviewProvider {
    static var previews: some View {
        OverlaySpinner()
    }
}
