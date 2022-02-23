//
//  CollectionPageViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import Combine
import SwiftUI

enum CollectionSheetContent {
    case ConnectForm
    case NFTDetails(address: String, tokenId: String)
    case MailForm(data: ComposeMailData)
}

@MainActor
final class CollectionPageViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var wallets: [NFTWallet] = []
    @Published private(set) var nfts: [NFTObject] = []

    @Published private(set) var filterBy: NFTWallet?
    
    @Published private(set) var loading: Bool = true
    
    @Published var sheetContent: CollectionSheetContent = .ConnectForm
    @Published var showingSheet: Bool = false
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Initialization
    
    init(
        walletPublisher: AnyPublisher<[NFTWallet], Never> = NFTWalletStorage.shared.list.eraseToAnyPublisher(),
        nftPublisher: AnyPublisher<[NFTObject], Never> = NFTObjectStorage.shared.list.eraseToAnyPublisher()
    ) {
        cancellable = Publishers.Zip(
            walletPublisher,
            nftPublisher
        ).sink(receiveValue: { [weak self] wallets, nfts in
            self?.wallets = wallets
            self?.nfts = nfts

            self?.loading = false
        })
    }
    
    // MARK: - Public Methods
    
    // Ref: https://github.com/renaudjenny/SwiftUI-with-Size-Classes
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

    func setFilterBy(wallet: NFTWallet) {
        filterBy = wallet
    }
    
    func clearFilterBy() {
        filterBy = nil
    }
    
    func presentConnectSheet() {
        sheetContent = .ConnectForm
        showingSheet.toggle()
    }
    
    func presentAssetSheet(address: String, tokenId: String) {
        sheetContent = .NFTDetails(address: address, tokenId: tokenId)
        showingSheet.toggle()
    }
    
    func presentMailFormSheet() {
        sheetContent = .MailForm(
            data: ComposeMailData(
                subject: "[BETA:EATWidget] - App Feedback",
                recipients: ["adrian@eatworks.xyz"],
                message: "Thank you for sharing your feedback, let us know what we can improve...",
                attachments: []
            )
        )
        showingSheet.toggle()
    }
}

