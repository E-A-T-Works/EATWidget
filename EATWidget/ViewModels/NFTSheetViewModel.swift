//
//  NFTSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import Foundation
import Combine

enum NFTSheetContent {
    case Tutorial
}

@MainActor
final class NFTSheetViewModel: ObservableObject {
    
    // MARK: - Properties
    
    let address: String
    let tokenId: String

    @Published private(set) var nft: CachedNFT?
    
    @Published private(set) var attributes: [CachedAttribute] = []
    @Published private(set) var actionButtons: [ActionRowButton] = []
    
    @Published var sheetContent: NFTSheetContent = .Tutorial
    @Published var showingSheet: Bool = false
    
    private let nftStorage = CachedNFTStorage.shared
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    
    // MARK: - Initialization
    
    init(address: String, tokenId: String) {
        self.address = address
        self.tokenId = tokenId
        
        load()
    }
    
    // MARK: - Loaders
    
    private func load() {
        fetchNFT()
    }
    
    private func fetchNFT() {
        let cached = nftStorage.fetch()
        nft = cached.first { $0.address == address && $0.tokenId == tokenId }
        
        resolveActionButtons()
        resolveAttributes()
    }

    private func resolveActionButtons() -> Void {
        var buttonsToSet = [ActionRowButton]()

        if (nft == nil) {
            actionButtons = buttonsToSet
            return
        }

        if nft!.openseaUrl != nil {
            buttonsToSet.append(
                ActionRowButton(
                    target: .Opensea,
                    url: nft!.openseaUrl!
                )
            )
        }

        actionButtons = buttonsToSet
    }
    
    private func resolveAttributes() -> Void {
        attributes = (nft?.attributes?.allObjects as? [CachedAttribute]) ?? []
    }
    
    
    // MARK: - Overlay
    
    func presentTutorialSheet() {
        sheetContent = .Tutorial
        showingSheet.toggle()
    }
    
    func dismiss() {
        shouldDismissView = true
    }
}
