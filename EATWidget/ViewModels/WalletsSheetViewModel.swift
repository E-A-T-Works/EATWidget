//
//  WalletsSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import Foundation
import Combine
import SwiftUI


@MainActor
final class WalletsSheetViewModel: ObservableObject {
    // MARK: - Properties

    @Published private(set) var wallets: [CachedWallet] = []
    
    @Published private(set) var loading: Bool = false
    
    @Published private(set) var isSyncing: Bool = false
    
    private let walletStorage = CachedWalletStorage.shared
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    // MARK: - Initialization
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        walletStorage.$list
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .assign(to: &$wallets)
    }
    
    
    // MARK: - Public Methods
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            do {
                guard let itemToDelete = (index > wallets.count ? nil : wallets[index]) else { return }
                try CachedWalletStorage.shared.delete(object: itemToDelete)
            } catch {
                print("⚠️ \(error)")
            }
        }
    }
    

    func dismiss() {
        self.shouldDismissView = true
    }
    
    func add() {}
    
    func sync() {
        isSyncing = true

        print("👀: sync start")
        
        Task {
            
            let syncProvider = SyncProvider.shared
            let queueToParseNFTs = OperationQueue()
            let queueToParseCollections = OperationQueue()
            
            //
            // setup helper variables
            var resultNFTs: [String: [NFTParseTask]] = [:]
            var resultCollections: [String: [Collection]] = [:]
            
            var parsedCount: [String: Int] = [:]
            var successCount: [String: Int] = [:]
            var failureCount: [String: Int] = [:]
            
            
            //
            // get all wallets
            let walletsToSync = syncProvider.getWallets()
            
            print("👀: got wallets")
            
            //
            // populate containers
            walletsToSync.map { $0.address! }.forEach { address in
                resultNFTs[address] = [NFTParseTask]()
                resultCollections[address] = [Collection]()
                parsedCount[address] = 0
                successCount[address] = 0
                failureCount[address] = 0
            }
            
            //
            // for each wallet do a lookup for what NFTs are available
            await walletsToSync.indices.asyncForEach { [walletsToSync] index in
                let wallet = walletsToSync[index]
                guard let address = wallet.address else { return }
                
                resultNFTs[address] = await syncProvider.lookupNFTsInWallet(for: address)
            }
            
            print("👀: did lookup")
            
            //
            // for each item run a parse operation
            walletsToSync.map { $0.address! }.forEach { address in
                guard let itemsToParse = resultNFTs[address] else { return }
                
                itemsToParse.indices.forEach { index in
                    let data = resultNFTs[address]![index]
                    let parseOp = ParseNFTOperation(data: data.raw)
                    parseOp.completionBlock = {
                        let parsed = parseOp.parsed
                    
                        var toUpdate = resultNFTs[address]![index]
                        toUpdate.state = parsed == nil ? .failure : .success
                        toUpdate.parsed = parsed
                        
                        resultNFTs[address]![index] = toUpdate
                        parsedCount[address]! += 1
                        
                        if parsed != nil {
                            successCount[address]! += 1
                        } else {
                            failureCount[address]! += 1
                        }
                    }
                    
                    queueToParseNFTs.addOperation(parseOp)
                }
            }
            
            //
            // wait for nft parsing to be done
            queueToParseNFTs.waitUntilAllOperationsAreFinished()
            
            print("👀: did parse nfts")
            
            //
            // parse the collections
            walletsToSync.indices.forEach { index in
                let wallet = walletsToSync[index]
                guard let address = wallet.address else { return }
                
                let itemsToParse = syncProvider.getCollectionsFromList(for: resultNFTs[address]!)
                
                itemsToParse.indices.forEach { index in
                    let data = itemsToParse[index]
                    let parseOp = ParseCollectionOperation(data: data)
                    
                    parseOp.completionBlock = {
                        guard let parsed = parseOp.parsed else { return }
                        
                        resultCollections[address]!.append(parsed)
                    }
                    
                    queueToParseCollections.addOperation(parseOp)
                }
            }
            
            //
            // wait for collection parsing to be done
            queueToParseCollections.waitUntilAllOperationsAreFinished()
            
            print("👀: did parse collections")
            
            //
            // Actually commit

            walletsToSync.indices.forEach { index in
                let wallet = walletsToSync[index]
                guard let address = wallet.address else { return }
                
                let toCacheCollections: [Collection] = resultCollections[address]!.compactMap { $0 }
                
                let toCacheNFTs: [NFT] = resultNFTs[address]!.filter { $0.state == .success }.map { $0.parsed }.compactMap { $0 }
                
                syncProvider.syncCollections(with: toCacheCollections)
                syncProvider.syncNFTs(with: toCacheNFTs, for: wallet)

            }
            
            print("👀: did commit")
            
            
            //
            // Log to results
            
            await walletsToSync.indices.asyncForEach { [walletsToSync] index in
                let wallet = walletsToSync[index]
                guard let address = wallet.address else { return }

//                await syncProvider.log(
//                    address: address,
//                    parsedCount: parsedCount[address]!,
//                    successCount: successCount[address]!,
//                    failureCount: failureCount[address]!
//                )
            }
            
            print("👀: did log")
            
        }
    }
    
}
