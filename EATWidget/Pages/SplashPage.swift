//
//  SplashPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/31/22.
//

import SwiftUI

struct SplashPage: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State var line1: String = ""
    @State var line2: String = ""
    @State var line3: String = ""
    
    var onComplete: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                HStack {
                    Image(
                        uiImage: UIImage(named: "eat-w-b-00")!
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42)
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                
                HStack {
                    if line1.isEmpty {
                        Spacer(minLength: 42)
                    } else {
                        Text(line1)
                            .font(.system(size: 42.0, design: .monospaced))
                            .fontWeight(.black)
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }

                    Spacer()
                }.padding(.horizontal)
                
                
                HStack {
                    if line2.isEmpty {
                        Spacer(minLength: 42)
                    } else {
                        Text(line2)
                            .font(.system(size: 42.0, design: .monospaced))
                            .fontWeight(.black)
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }.padding(.horizontal)
                
                HStack {
                    if line3.isEmpty {
                        Spacer(minLength: 42)
                    } else {
                        Text(line3)
                            .font(.system(size: 42.0, design: .monospaced))
                            .fontWeight(.black)
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }.padding(.horizontal)
            }.padding(.bottom, safeAreaInsets.bottom)
        }
        .ignoresSafeArea()
        .onAppear {
            let l1 = "e.xperiments"
            let l2 = "a.rt"
            let l3 = "t.echnology_"
            
            let delta = 0.1
            
            l1.enumerated().forEach { index, character in
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * delta) {
                    
                  line1 += String(character)
                    
                }
            }
            
            l2.enumerated().forEach { index, character in
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(l1.count) * delta) + Double(index) * delta) {
                    
                  line2 += String(character)
                    
                }
            }
            
            
            l3.enumerated().forEach { index, character in
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(l1.count) * delta) + (Double(l2.count) * delta) + Double(index) * delta) {
                    
                  line3 += String(character)
                    
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(l1.count) * delta) + (Double(l2.count) * delta) + (Double(l3.count) * delta) + 0.5) {
                
                if onComplete != nil {
                    onComplete!()
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
