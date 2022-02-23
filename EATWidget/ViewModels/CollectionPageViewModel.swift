//
//  CollectionPageViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import Combine

enum CollectionSheetContent {
    case ConnectForm
    case NFTDetails(address: String, tokenId: String)
    case MailForm(data: ComposeMailData)
}

@MainActor
final class CollectionPageViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published private(set) var loading: Bool = true
    @Published private(set) var empty: Bool = false
    
    @Published private(set) var columns: Int = 2
    
    @Published private(set) var wallets: [NFTWallet] = []
    @Published private(set) var nfts: [NFTObject] = []

    @Published private(set) var filterBy: String?
    
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
    
    func setFilterBy(wallet: NFTWallet) {
        filterBy = wallet.address!
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

