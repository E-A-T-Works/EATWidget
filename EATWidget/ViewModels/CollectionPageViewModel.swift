//
//  CollectionPageViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import Combine


@MainActor
final class CollectionPageViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var wallets: [Wallet] = []
    @Published private(set) var assets: [Asset] = []
    
    @Published private(set) var assetsByWallet: [String:[Asset]] = [:]
    
    @Published var showingConnectSheet: Bool = false
    @Published var showingAssetSheet: Bool = false
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Initialization
    
    init(walletPublisher: AnyPublisher<[Wallet], Never> = WalletStorage.shared.wallets.eraseToAnyPublisher()) {
        cancellable = walletPublisher.sink { wallets in
            self.wallets = wallets
        }
    }
    
    // MARK: - Public Methods
    
    func presentConnectSheet() {
        showingConnectSheet.toggle()
    }

    func load() {
        Task {
            do {
                self.assetsByWallet = try await self.wallets.asyncMap { wallet -> [String: [Asset]] in
                    let address = wallet.address!
                    let assets = try await AssetProvider.fetchAssets(ownerAddress: address)
                    
                    return [address: assets]
                }
                .flatMap { $0 }
                .reduce([String:[Asset]]()) { acc, curr in
                    var nextDict = acc
                    nextDict.updateValue(curr.value, forKey: curr.key)
                    return nextDict
                }
                
                self.assets = self.assetsByWallet.reduce(into: []) {  acc, curr in
                    acc += curr.value
                }

            } catch {
                print("⚠️ (CanvasPageViewModel)::load() \(error)")
            }
        }
    }
}

