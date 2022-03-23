//
//  SyncWalletCacheOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation
import Firebase
import FirebaseAuth

final class SyncWalletCacheOperation: AsyncOperation {
    
    private let list: [Wallet]
    private let completionHandler: (() -> Void)?
    
    private let storage = NFTWalletStorage.shared
    
    init(list: [Wallet], completionHandler: (() -> Void)? = nil) {
        self.list = list
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {
            
            let updatedCache = storage.sync(list: list)
        
            // Sync Results
        
            guard Auth.auth().currentUser != nil else {
                state = .finished
                return
            }
            
            let db = Firestore.firestore()
            
            await updatedCache.concurrentForEach { wallet in
                do {
                    try await db
                        .collection("wallets")
                        .document(wallet.address!)
                        .setData([
                            "timestamp": Date()
                        ])
                } catch {
                    print("⚠️ Failed to log to firestore \(error)")
                }
            }
        
        
            // mark task as done
            state = .finished
        }
    }
    
}
