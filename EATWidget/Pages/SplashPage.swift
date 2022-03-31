//
//  SplashPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/31/22.
//

import SwiftUI

struct SplashPage: View {
    
    @State var line1: String = "e."
    @State var line2: String = "a."
    @State var line3: String = "t."
    
    var body: some View {
        ZStack {

            
            VStack(alignment: .leading) {
                
                HStack {
                    Branding()
                        .frame(width: 42, height: 42)
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                
                HStack {
                    Text(line1)
                        .font(.system(size: 42.0, design: .monospaced))
                        .fontWeight(.black)
                        .lineLimit(1)
                        .animation(.easeIn, value: line1.count)
                    
                    Spacer()
                }.padding(.horizontal)
                
                
                HStack {
                    Text(line2)
                        .font(.system(size: 42.0, design: .monospaced))
                        .fontWeight(.black)
                        .lineLimit(1)
                        .animation(.easeIn, value: line1.count)
                    
                    Spacer()
                }.padding(.horizontal)
                
                HStack {
                    Text(line3)
                        .font(.system(size: 42.0, design: .monospaced))
                        .fontWeight(.black)
                        .lineLimit(1)
                        .animation(.easeIn, value: line1.count)
                    
                    Spacer()
                }.padding(.horizontal)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            "xperiments".enumerated().forEach { index, character in
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                    
                  line1 += String(character)
                    
                }
            }
            
            "rt".enumerated().forEach { index, character in
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                    
                  line2 += String(character)
                    
                }
            }
            
            
            "echnology_".enumerated().forEach { index, character in
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                    
                  line3 += String(character)
                    
                }
            }
        }
    }
}

struct SplashPage_Previews: PreviewProvider {
    static var previews: some View {
        SplashPage()
    }
}
