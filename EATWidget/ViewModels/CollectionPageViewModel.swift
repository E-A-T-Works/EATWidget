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
    case NFTDetails(contractAddress: String, tokenId: String)
    case MailForm(data: ComposeMailData)
}

@MainActor
final class CollectionPageViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published private(set) var loading: Bool = true
    
    @Published private(set) var columns: Int = 2

    @Published private(set) var wallets: [Wallet] = []
    @Published private(set) var list: [NFT] = []
    
    @Published private(set) var listByWallet: [String:[NFT]] = [:]
    
    @Published var sheetContent: CollectionSheetContent = .ConnectForm
    @Published var showingSheet: Bool = false
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Initialization
    
    init(walletPublisher: AnyPublisher<[Wallet], Never> = WalletStorage.shared.wallets.eraseToAnyPublisher()) {
        cancellable = walletPublisher.sink { wallets in
            self.wallets = wallets
        }
    }
    
    // MARK: - Public Methods
    
    func presentConnectSheet() {
        sheetContent = .ConnectForm
        showingSheet.toggle()
    }
    
    func presentAssetSheet(contractAddress: String, tokenId: String) {
        sheetContent = .NFTDetails(contractAddress: contractAddress, tokenId: tokenId)
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

    func load() {
        Task {
            do {
                self.loading = true
                
                self.listByWallet = try await self.wallets.asyncMap { wallet -> [String: [NFT]] in
                    let address = wallet.address!
                    let list = try await NFTProvider.fetchNFTs(ownerAddress: address)
                    return [address: list]
                }
                .flatMap { $0 }
                .reduce([String:[NFT]]()) { acc, curr in
                    var nextDict = acc
                    nextDict.updateValue(curr.value, forKey: curr.key)
                    return nextDict
                }

                self.list = self.listByWallet.reduce(into: []) {  acc, curr in
                    acc += curr.value
                }
                
                self.loading = false

            } catch {
                print("⚠️ (CanvasPageViewModel)::load() \(error)")
                self.loading = false
            }
        }
    }
}

