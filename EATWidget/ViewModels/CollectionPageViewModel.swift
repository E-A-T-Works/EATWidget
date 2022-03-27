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
    
    @Published private(set) var collection: Collection?
    
    @Published private(set) var owned: [NFTObject] = []
    @Published private(set) var everything: [NFT] = []
    
    @Published private(set) var loading: Bool = false
    
    @Published var sheetContent: CollectionPageSheetContent? = nil
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
    
    func presentNFTDetailsSheet(address: String, tokenId: String) {
        sheetContent = .NFTDetails(address: address, tokenId: tokenId)
        showingSheet.toggle()
    }
    
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
