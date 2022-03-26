//
//  CollectionPageViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/25/22.
//

import Foundation
import Combine
import SwiftUI

enum CollectionPageSheetContent {
    case NFTDetails(address: String, tokenId: String)
}

enum CollectionPageTabs {
    case list
    case detail
}

@MainActor
final class CollectionPageViewModel: ObservableObject {
    
    // MARK: - Properties
    
    let address: String
    
    
    
    @Published private(set) var collection: Collection?
    
    @Published private(set) var owned: [NFTObject] = []
    @Published private(set) var remaining: [NFT] = []
    
    @Published private(set) var loading: Bool = false
    
    
    @Published var tab: CollectionPageTabs = .list
    
    @Published var sheetContent: CollectionPageSheetContent = .NFTDetails(address: "", tokenId: "")
    @Published var showingSheet: Bool = false
    
    private let objectStorage = NFTObjectStorage.shared
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    // MARK: - Initialization
    
    init(address: String) {
        self.address = address
        
        load()
    }
    
    private func load() {
        fetchOwnedNFTs()
        fetchCollectionNFTs()
        fetchCollection()
    }
    
    
    private func fetchOwnedNFTs() {
        let cached = objectStorage.fetch().filter { $0.address == address }
        
        owned = cached
    }
    
    private func fetchCollectionNFTs() {
        Task {
            loading = true
            
            do {
                let results = try await api.getNFTsForCollection(for: address)
                
                print(results.count)
            } catch {
                print("⚠️ \(error)")
            }
            
            loading = false
        }
    }
    
    
    private func fetchCollection() {
        Task {
            collection = await fb.loadCollection(for: address)
        }
    }
    
    
    func changeTabs(to tab:CollectionPageTabs) {
        self.tab = tab
    }
}
