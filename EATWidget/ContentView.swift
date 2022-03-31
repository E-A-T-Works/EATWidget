//
//  ContentView.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI


struct ContentView: View {
    
    @State var splashing: Bool = true
    
    var body: some View {
        ZStack {
            if splashing {
                SplashPage()
            } else {
                NavigationView {
                    HomePage()
                }
                .navigationViewStyle(.stack)
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                splashing = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
