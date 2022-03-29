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
    case MailForm(data: ComposeMailData)
}

@MainActor
final class CollectionPageViewModel: ObservableObject {
    
    // MARK: - Properties
    
    let address: String
        
    @Published private(set) var collection: CachedCollection?
    
    @Published private(set) var collected: [CachedNFT] = []
    @Published private(set) var everything: [NFT] = []
    
    @Published var sheetContent: CollectionPageSheetContent? = nil
    @Published var showingSheet: Bool = false
    
    private let collectionStorage = CachedCollectionStorage.shared
    private let nftStorage = CachedNFTStorage.shared
    
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    
    // MARK: - Initialization
    
    init(address: String) {
        self.address = address
        
        load()
    }
    
    
    // MARK: - Loaders
    
    private func load() {
        fetchCollection()
        fetchCollectedNFTs()
        fetchAllNFTs()
    }
    
    
    private func fetchCollection() {
        let cached = collectionStorage.fetch()
        collection = cached.first { $0.address == address }
    }
    
    private func fetchCollectedNFTs() {
        let cached = nftStorage.fetch().filter { $0.address == address }
        
        collected = cached
    }
    
    private func fetchAllNFTs() {
        Task {
            do {
                let _ = try await api.getNFTsForCollection(for: address)
            } catch {
                print("⚠️ \(error)")
            }
        }
    }
    
    
    // MARK: - Overlay

    
    func presentNFTDetailsSheet(address: String, tokenId: String) {
        sheetContent = .NFTDetails(address: address, tokenId: tokenId)
        showingSheet.toggle()
    }
    
    // MARK: - Other
    
    func determineColumns(vertical: UserInterfaceSizeClass?, horizontal: UserInterfaceSizeClass?) -> Int {
        if vertical == .regular && horizontal == .compact {
            // iPhone Portrait or iPad 1/3 split view for Multitasking for instance
            return 2
        } else if vertical == .compact && horizontal == .compact {
            // some "standard" iPhone Landscape (iPhone SE, X, XS, 7, 8, ...)
            return 3
        } else if vertical == .compact && horizontal == .regular {
            // some "bigger" iPhone Landscape (iPhone Xs Max, 6s Plus, 7 Plus, 8 Plus, ...)
            return 4
        } else if vertical == .regular && horizontal == .regular {
            // macOS or iPad without split view - no Multitasking
            return 4
        } else {
            return 2
        }
    }
}
