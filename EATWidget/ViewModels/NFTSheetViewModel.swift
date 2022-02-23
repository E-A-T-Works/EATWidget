//
//  NFTSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import Foundation
import Combine


@MainActor
final class NFTSheetViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var loading: Bool = true
    @Published private(set) var error: Bool = false
    
    @Published private(set) var nft: NFTObject?
    
    @Published private(set) var actionButtons: [ActionRowButton] = []
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Public Methods
    
    func dismiss() {
        shouldDismissView = true
    }
    
    // MARK: API Handlers
    
    func load(address: String, tokenId: String) {
        Task {
            self.loading = true
            
            guard let nft = (NFTObjectStorage.shared.fetch().first {
                $0.address == address && $0.tokenId == tokenId
            }) else {
                self.error = true
                self.loading = false
                return
            }
            
            self.nft = nft

            resolveActionButtons()
            
            self.loading = false
        }
    }

    private func resolveActionButtons() -> Void {
        var buttonsToSet = [ActionRowButton]()

        if nft == nil {
            actionButtons = buttonsToSet
            return
        }

        buttonsToSet.append(
            ActionRowButton(
                target: .Opensea,
                url: URL(string: "https://opensea.io/assets/\(nft!.address!)/\(nft!.tokenId!)")!
            )
        )
    
        actionButtons = buttonsToSet
    }
}
