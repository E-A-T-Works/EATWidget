//
//  SyncWalletOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation
import Firebase

final class SyncWalletOperation: AsyncOperation {
    
    private let wallet: CachedWallet
    private let completionHandler: ((NFT?) -> Void)?
    
    private let nftStorage: CachedNFTStorage = CachedNFTStorage.shared
    private let collectionStorage: CachedCollectionStorage = CachedCollectionStorage.shared
    
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    private let adapters: NFTAdapters = NFTAdapters.shared
    
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
            
//            //
//            // lookup
//            //
//            
//            var results: [APIAlchemyNFT] = [APIAlchemyNFT]()
//            do {
//                results = try await api.getNFTs(for: address)
//            } catch {
//                print("⚠️ sync::lookup \(error)")
//                state = .finished
//                return
//            }
//            
//            //
//            // parse nfts
//            //
//            
//            var nfts: [NFT] = [NFT]()
//
//            results.indices.forEach { index in
//                let data = results[index]
//
//                let parseOp = ParseNFTOperation(data: data)
//                parseOp.completionBlock = {
//                    guard let parsed = parseOp.parsed else { return }
//                    nfts.append(parsed)
//                }
//
//                queue.addOperation(parseOp)
//            }
//
//            queue.waitUntilAllOperationsAreFinished()
//
//            print("done w nfts \(nfts.count)")
//            
//            //
//            // parse collections
//            //
//            
//            var collections: [Collection] = [Collection]()
//
//            let addresses = nfts
//                .map { $0.address }
//                .compactMap { $0 }
//                .unique()
//
//            addresses.indices.forEach { index in
//                let address = addresses[index]
//
//                let parseOp = ParseCollectionOperation(address: address)
//
//                parseOp.completionBlock = {
//                    guard let parsed = parseOp.parsed else { return }
//                    collections.append(parsed)
//                }
//
//                queue.addOperation(parseOp)
//            }
//
//            queue.waitUntilAllOperationsAreFinished()
//            
//            print("done w collections \(collections.count)")
//
//            //
//            // compare
//            //
//
//            let _ = try? collectionStorage.sync(list: collections)
//            let _ = try? nftStorage.sync(wallet: wallet, list: nfts)
//            
            // mark task as done
            state = .finished
        }

    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}

