//
//  SyncProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 4/27/22.
//

import Foundation
import Firebase


final class SyncProvider {
    static let shared: SyncProvider = SyncProvider()
    
    private let walletStorage: CachedWalletStorage = CachedWalletStorage.shared
    private let nftStorage: CachedNFTStorage = CachedNFTStorage.shared
    private let collectionStorage: CachedCollectionStorage = CachedCollectionStorage.shared
    
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    init() {
        
    }
    
    // ----------------
    
    func lookup() {}
    
    func parse() {}
    
    func sync() {}
    
    
    // ----------------
    

    func getWallets() -> [CachedWallet] {
        return walletStorage.fetch()
    }
    
    func lookupNFTsInWallet(for address: String) async -> [NFTParseTask]  {
        
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
    
    func setParsedData(for nft: NFT) {}
    
    func getCollectionsFromList(for list: [NFTParseTask]) -> [APICollection] {
        let collections = list
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

    func syncCollections(with list: [Collection]) {
        do {
            let _ = try collectionStorage.sync(list: list)
        } catch {
            print("⚠️ \(error)")
        }
    }
    
    func syncNFTs(with list: [NFT], for wallet: CachedWallet) {
        do {
            let _ = try nftStorage.sync(wallet: wallet, list: list)
        } catch {
            print("⚠️ \(error)")
        }
    }
    
    func log(address: String, parsedCount: Int, successCount: Int, failureCount: Int) async {
        await fb.logWallet(
            address: address,
            parsedCount: parsedCount,
            successCount: successCount,
            failureCount: failureCount
        )
    }
}

