//
//  RefreshAppContentsOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 4/11/22.
//

import Foundation

final class RefreshAppContentsOperation: AsyncOperation {
    
    private let queue = OperationQueue()
    
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    override func main() {
        
        Task {
         
            await fb.logRefresh()
            
            queue.waitUntilAllOperationsAreFinished()
            
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}
