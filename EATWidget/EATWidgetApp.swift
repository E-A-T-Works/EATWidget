//
//  EATWidgetApp.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct EATWidgetApp: App {
    
    init() {
        // TODO: Move this to a more appropriate place
        
        ///
        /// Configure Firebase + Create an anonymous signed in session so that
        /// we can enfore aith check on firestore resources
        ///
        
        FirebaseApp.configure()
        
        guard let currentUser = Auth.auth().currentUser else {
            Auth.auth().signInAnonymously { authResult, error in
                guard let user = authResult?.user else {
                    print("🆘 Failed to create session")
                    return
                }
                print("🟨 Session created: \(user.uid)")
            }
            return
        }
        print("✅ Session exists: \(currentUser.uid)")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
