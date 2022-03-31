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
                SplashPage() {
                    print("!!!!")
                    
                    splashing = false
                }
            } else {
                NavigationView {
                    HomePage()
                }
                .navigationViewStyle(.stack)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
