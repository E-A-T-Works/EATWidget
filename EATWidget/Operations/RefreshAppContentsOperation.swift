//
//  RefreshAppContentsOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 4/11/22.
//

import Foundation

final class RefreshAppContentsOperation: AsyncOperation {

    private let cachedWalletStorage: CachedWalletStorage = CachedWalletStorage.shared
    
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    override func main() {
        Task {
            let wallets = cachedWalletStorage.fetch()
            
            await wallets.asyncForEach { wallet in
                guard let address = wallet.address else { return }
                let syncProvider = SyncProvider(address: address)
                await syncProvider.parse()
                await syncProvider.sync()
            }
            
            await fb.logRefresh()

            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
    }
}
