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
    
    @Published private(set) var collected: [CachedNFT] = []
    @Published private(set) var everything: [NFT] = []
    
    @Published private(set) var loading: Bool = false
    
    @Published var sheetContent: CollectionPageSheetContent? = nil
    @Published var showingSheet: Bool = false
    
    private let objectStorage = CachedNFTStorage.shared
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
        Task {
            loading = true
            
            let annotated = await fb.loadCollection(for: address)
            
            if annotated != nil {
                collection = annotated
            } else {
                collection = Collection(
                    id: UUID().uuidString,
                    address: address,
                    title: "Unkown Collection",
                    text: nil,
                    links: [ExternalLink](),
                    banner: URL(string: "https://via.placeholder.com/640x360")!,
                    thumbnail: URL(string: "https://via.placeholder.com/150x150")!
                )
            }
            
            print(collection)
            
            loading = false
        }
    }
    
    private func fetchCollectedNFTs() {
        let cached = objectStorage.fetch().filter { $0.address == address }
        
        collected = cached
    }
    
    private func fetchAllNFTs() {
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
