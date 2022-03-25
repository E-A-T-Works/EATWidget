//
//  HomePageViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import Combine
import SwiftUI

enum HomePageSheetContent {
    case ConnectForm
    case NFTDetails(address: String, tokenId: String)
    case NFTWallets
    case Tutorial
    case MailForm(data: ComposeMailData)
}

@MainActor
final class HomePageViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var wallets: [NFTWallet] = []
    @Published private(set) var nfts: [NFTObject] = []
    @Published private(set) var addresses: [String] = []
    
    @Published private(set) var filterBy: NFTWallet?
    
    @Published private(set) var loading: Bool = false
    
    @Published var sheetContent: HomePageSheetContent = .ConnectForm
    @Published var showingSheet: Bool = false
    
    private let walletStorage = NFTWalletStorage.shared
    private let objectStorage = NFTObjectStorage.shared
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    
    
    // MARK: - Initialization
    
    init() {
        setupSubscriptions()
        autoPresentConnectSheetIfNeeded()
    }
    
    private func setupSubscriptions() {
        walletStorage.$list
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .assign(to: &$wallets)
        
        objectStorage.$list
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .assign(to: &$nfts)
        
        Publishers.CombineLatest(objectStorage.$list, $filterBy)
            .receive(on: RunLoop.main)
            .map { (list, filterBy) -> [NFTObject] in
                if filterBy != nil {
                    return list.filter { $0.wallet?.objectID == filterBy?.objectID }
                } else {
                    return list
                }
            }
            .compactMap { $0 }
            .map { $0.filter { $0.address != nil }.map { $0.address! }.unique() }
            .removeDuplicates { prev, curr in
                prev.elementsEqual(curr)
            }
            .assign(to: &$addresses)
    }
    
    private func autoPresentConnectSheetIfNeeded() {
        let list = walletStorage.fetch()
        
        guard list.isEmpty else { return }
        
        presentConnectSheet()
    }
    
    // MARK: - Public Methods

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
    
    func presentNFTDetailsSheet(address: String, tokenId: String) {
        sheetContent = .NFTDetails(address: address, tokenId: tokenId)
        showingSheet.toggle()
    }
    
    func presentWalletsSheet() {
        sheetContent = .NFTWallets
        showingSheet.toggle()
    }
    
    func presentTutorialSheet() {
        sheetContent = .Tutorial
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
    
    
    // MARK: - Sync

    private let queue = OperationQueue()
    
    func sync() {
        
        let wallets = walletStorage.fetch()
        
        print("➡️ syncing \(wallets.count) wallets...")
        
        wallets.forEach { wallet in
            let syncOp = SyncWalletOperation(wallet: wallet)
            syncOp.completionBlock = { }
            queue.addOperation(syncOp)
        }
        
        DispatchQueue(label: "xyz.eatworks.app.worker", qos: .userInitiated).async { [weak self] in
            
            self?.queue.waitUntilAllOperationsAreFinished()

            DispatchQueue.main.async {
                print("♻️ done with sync")
            }
        }
    }
}

