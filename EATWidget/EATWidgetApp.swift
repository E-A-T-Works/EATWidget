//
//  EATWidgetApp.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

@main
struct EATWidgetApp: App {
    var body: some Scene {
        // TODO: Replace this with ContentView which handles openURL
        // see: https://medium.com/@karaiskc/programmatic-navigation-in-swiftui-30b75613f285
        
        WindowGroup {
            NavigationView {
                CollectionPage()
            }
            .navigationViewStyle(.stack)
        }
    }
}
