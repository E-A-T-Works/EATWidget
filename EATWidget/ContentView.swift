//
//  ContentView.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            CollectionPage()
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
