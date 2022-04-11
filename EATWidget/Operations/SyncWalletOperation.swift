//
//  SyncWalletOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation
import Firebase

final class SyncWalletOperation: AsyncOperation {
    private(set) var collections: [Collection] = [Collection]()
    
    private(set) var list: [NFTParseTask] = [NFTParseTask]()
    private(set) var parsedCount: Int = 0
    private(set) var successCount: Int = 0
    private(set) var failureCount: Int = 0
    
    
    private let wallet: CachedWallet
    private let completionHandler: ((NFT?) -> Void)?
    
    private let nftStorage: CachedNFTStorage = CachedNFTStorage.shared
    private let collectionStorage: CachedCollectionStorage = CachedCollectionStorage.shared
    
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    private let queue = OperationQueue()
    
    init(wallet: CachedWallet, completionHandler: ((NFT?) -> Void)? = nil) {
        self.wallet = wallet
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        
        guard let address = wallet.address else {
            state = .finished
            return
        }
        
        Task {
            print("❇️ START:SYNC: \(address)")
            
            await lookup(for: address)
            await parse()
            
            let toCache: [NFT] = list.filter { $0.state == .success }.map { $0.parsed }.compactMap { $0 }
            
            do {
                let _ = try collectionStorage.sync(list: collections)
                let _ = try nftStorage.sync(wallet: wallet, list: toCache)
            } catch {
                
            }
            
            await fb.logWallet(address: address, parsedCount: parsedCount, successCount: successCount, failureCount: failureCount)
            
        
            print("✅ DONE:SYNC: \(address)")
            
            state = .finished
        }

    }
    
    override func cancel() {
        super.cancel()
        
        // Do any other cleanup
        
        queue.cancelAllOperations()
    }
    
    
    func lookup(for address: String) async {
        let api = APIOpenseaProvider()
        var results: [API_NFT] = [API_NFT]()
        
        do {
            results = try await api.getNFTs(for: address)
        } catch {
            print("⚠️ \(error)")
        }
        
        list = results.map {
            NFTParseTask(
                id: $0.id,
                address: $0.address,
                tokenId: $0.tokenId,
                state: .pending,
                collection: $0.collection,
                raw: $0,
                parsed: nil
            )
        }
    }
    
    func parse() async {
        
        ///
        /// Parse the NFTs
        ///
        
        list.indices.forEach { index in
            let data = list[index]
            
            let parseOp = ParseNFTOperation(data: data.raw)

            parseOp.completionBlock = {
                DispatchQueue.main.async {
                    
                    let parsed = parseOp.parsed
                    
                    var data = self.list[index]
                    data.state = parsed == nil ? .failure : .success
                    data.parsed = parseOp.parsed
                    
                    self.list[index] = data
                    
                    self.parsedCount += 1
                    
                    if parsed == nil {
                        self.failureCount += 1
                    } else {
                        self.successCount += 1
                    }
                    
                    
                }
            }

            queue.addOperation(parseOp)
        }
        
        ///
        /// Parse the Collections
        ///
        
        let collections = list
            .map { $0.collection }
            .compactMap { $0 }

        var uniqueCollections = [APICollection]()
        for item in collections {
            if !uniqueCollections.contains(where: {$0.id == item.id }) {
                uniqueCollections.append(item)
            }
        }

        uniqueCollections.indices.forEach { index in
            let data = uniqueCollections[index]

            let parseOp = ParseCollectionOperation(data: data)

            parseOp.completionBlock = {
                DispatchQueue.main.async {
                    guard let parsed = parseOp.parsed else { return }
                    self.collections.append(parsed)
                }
            }

            queue.addOperation(parseOp)
        }
        
        
        queue.waitUntilAllOperationsAreFinished()
    }
}

