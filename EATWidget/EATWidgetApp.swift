//
//  EATWidgetApp.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

@main
struct EATWidgetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
