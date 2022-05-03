//
//  SyncProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 5/3/22.
//

import Foundation
import Combine


final class SyncProvider: ObservableObject {
    
    let address: String


    @Published var nftsToParse: [NFTParseTask] = [NFTParseTask]()
    @Published var collectionsToParse: [APICollection] = [APICollection]()
    
    @Published var nfts: [NFT] = [NFT]()
    @Published var collections: [Collection] = [Collection]()
    
    @Published var parsedCount: Int = 0
    @Published var successCount: Int = 0
    @Published var failureCount: Int = 0
    
    @Published var syncing: Bool = false
    
    private let nftAdapters: NFTAdapters = NFTAdapters.shared
    private let collectionAdapters: CollectionAdapters = CollectionAdapters.shared
    
    private let walletStorage: CachedWalletStorage = CachedWalletStorage.shared
    private let nftStorage: CachedNFTStorage = CachedNFTStorage.shared
    private let collectionStorage: CachedCollectionStorage = CachedCollectionStorage.shared


    init(address: String) {
        self.address = address
    }
    
    
    func parse() async {
        syncing = true
        
        nftsToParse = await lookupNFTsInWallet()
        
        await nftsToParse.indices.asyncForEach({ [self] index in
            let item = self.nftsToParse[index]
            
            let parsed = await nftAdapters.parse(item: item.raw)
            
            var toUpdate = self.nftsToParse[index]
            self.parsedCount += 1

            if parsed != nil {
                toUpdate.parsed = parsed
                toUpdate.state = .success

                self.successCount += 1

                self.nfts.append(parsed!)
            } else {
                toUpdate.parsed = nil
                toUpdate.state = .failure

                self.failureCount += 1
            }

            self.nftsToParse[index] = toUpdate
        })
        
        collectionsToParse = getCollections()
        
        await collectionsToParse.indices.asyncForEach({ [self] index in
            let item = self.collectionsToParse[index]
            
            guard let parsed = await collectionAdapters.parse(item: item) else { return }
            
            self.collections.append(parsed)
        })
        
        syncing = false
    }
    
    func sync() async {
        
        guard let wallet = walletStorage.fetch().first(where: { cached in
            cached.address == address
        }) else { return }
        
        do {
            let _ = try nftStorage.sync(wallet: wallet, list: nfts)
        } catch { print("⚠️ Failed To Sync NFTs \(error)")}
        
        do {
            let _ = try collectionStorage.sync(list: collections)
        } catch { print("⚠️ Failed To Sync Collections \(error)")}
        
    }
    
    // MARK: - Helpers
    
    private func lookupNFTsInWallet() async -> [NFTParseTask]  {
        
        let api = APIOpenseaProvider()
        var results: [API_NFT] = [API_NFT]()
        
        do {
            results = try await api.getNFTs(for: address)
        } catch {
            print("⚠️ \(error)")
        }
        
        return results.map {
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
    
    
    private func getCollections() -> [APICollection] {
        let collections = nftsToParse
            .map { $0.collection }
            .compactMap { $0 }
        
        var uniqueCollections = [APICollection]()
        for item in collections {
            if !uniqueCollections.contains(where: {$0.id == item.id }) {
                uniqueCollections.append(item)
            }
        }
        
        return uniqueCollections
    }
    
    
}
