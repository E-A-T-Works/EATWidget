//
//  EATWidgetApp.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import BackgroundTasks
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
    
        ///
        /// Schedule background refresh
        ///
        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "xyz.eatworks.EATWidget.tasks.refresh", using: nil) { [self] task in
//             self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "xyz.eatworks.EATWidget.tasks.refresh")
        // Fetch no earlier than 15 minutes from now.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        // Schedule a new refresh task.
        scheduleAppRefresh()

        // Create an operation that performs the main part of the background task.
        let operation = RefreshAppContentsOperation()
       
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
            operation.cancel()
        }

        // Inform the system that the background task is complete
        // when the operation completes.
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }

        // Start the operation.
        queue.addOperation(operation)
    }
}
