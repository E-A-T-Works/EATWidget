//
//  SyncWalletOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation
import Firebase

final class SyncWalletOperation: AsyncOperation {
    
    private let wallet: NFTWallet
    private let completionHandler: ((NFT?) -> Void)?
    
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    private let adapters: NFTAdapters = NFTAdapters.shared
    private let storage: NFTObjectStorage = NFTObjectStorage.shared
    
    init(wallet: NFTWallet, completionHandler: ((NFT?) -> Void)? = nil) {
        self.wallet = wallet
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {
            
            guard let address = wallet.address else {
                state = .finished
                return
            }
            
            // lookup
            var results: [APIAlchemyNFT] = [APIAlchemyNFT]()
            do {
                results = try await api.getNFTs(for: address)
            } catch {
                print("⚠️ sync::lookup \(error)")
                state = .finished
                return
            }
            
            // parse
            var parsed: [NFT] = [NFT]()
            do {
                parsed = try await results.concurrentMap({ data in
                    await self.adapters.parse(item: data)
                }).compactMap { $0 }
                
            } catch {
                print("⚠️ sync::parse \(error)")
                state = .finished
                return
            }
            print("➡️ parse: \(address) | \(parsed.count)")
            
            
            // store
            print("➡️ store: \(address)")
            do {
                let _ = try storage.sync(wallet: wallet, list: parsed)
            } catch {
                print("⚠️ sync::store \(error)")
                state = .finished
                return
            }

            // Sync Results
            
//                guard Auth.auth().currentUser != nil else {
//                    state = .finished
//                    return
//                }
//
//                let db = Firestore.firestore()
//
//                await list.map { $0?.tokenId }.concurrentForEach({ tokenId in
//
//                    do {
//                        try await db
//                            .collection("contracts")
//                            .document(address)
//                            .collection("assets")
//                            .document(tokenId)
//                            .setData([
//                                "success": tokenId != nil,
//                                "timestamp": Date()
//                            ])
//                    } catch {
//                        print("⚠️ Failed to log to firestore \(error)")
//                    }
//                })

                

            // mark task as done
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}

