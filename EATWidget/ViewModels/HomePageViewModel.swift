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
    case Wallets
    case Tutorial
    case MailForm(data: ComposeMailData)
}

@MainActor
final class HomePageViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var wallets: [CachedWallet] = []
    @Published private(set) var nfts: [CachedNFT] = []
    @Published private(set) var addresses: [String] = []
    
    @Published private(set) var filterBy: CachedWallet?
    
    @Published private(set) var loading: Bool = false
    
    @Published var sheetContent: HomePageSheetContent = .ConnectForm
    @Published var showingSheet: Bool = false
    
    @Published var nextPageAddress: String = ""
    @Published var nextPage: String? = nil
    
    private let walletStorage = CachedWalletStorage.shared
    private let nftStorage = CachedNFTStorage.shared
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    
    
    // MARK: - Initialization
    
    init() {
        setupSubscriptions()
        autoPresentConnectSheetIfNeeded()
    }
    
    private func setupSubscriptions() {
        walletStorage.$list
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .assign(to: &$wallets)
        
        Publishers.CombineLatest(nftStorage.$list, $filterBy)
            .map { (list, filterBy) -> [CachedNFT] in
                if filterBy != nil {
                    return list.filter { $0.wallet?.objectID == filterBy?.objectID }
                } else {
                    return list
                }
            }
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .assign(to: &$nfts)
        
        $nfts
            .map { $0.filter { $0.address != nil }.map { $0.address! }.unique() }
            .removeDuplicates { prev, curr in
                prev.elementsEqual(curr)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$addresses)
    }
    
    private func autoPresentConnectSheetIfNeeded() {
        let list = walletStorage.fetch()
        
        guard list.isEmpty else { return }
        
        presentConnectSheet()
    }
    
    // MARK: - Public Methods

    func setFilterBy(wallet: CachedWallet) {
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
        sheetContent = .Wallets
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

