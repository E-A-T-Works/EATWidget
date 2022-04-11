//
//  RefreshAppContentsOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 4/11/22.
//

import Foundation

final class RefreshAppContentsOperation: AsyncOperation {

    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    private let cachedWalletStorage: CachedWalletStorage = CachedWalletStorage.shared
    
    private let queue = OperationQueue()
    
    override func main() {
        Task {
            print("❇️ RefreshAppContentsOperation::START:")
            
            let cachedWallets = cachedWalletStorage.fetch()
            
            cachedWallets.indices.forEach { index in
                let data = cachedWallets[index]
                let syncOp = SyncWalletOperation(wallet: data)
                
                queue.addOperation(syncOp)
            }

            queue.waitUntilAllOperationsAreFinished()
            
            await fb.logRefresh()
            
            print("✅ RefreshAppContentsOperation::END:")
            
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        
        // Do any other cleanup
        
        queue.cancelAllOperations()
    }
}
