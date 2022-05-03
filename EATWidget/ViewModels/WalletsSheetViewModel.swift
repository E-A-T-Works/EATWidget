//
//  WalletsSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import Foundation
import Combine
import SwiftUI


@MainActor
final class WalletsSheetViewModel: ObservableObject {
    // MARK: - Properties

    @Published private(set) var wallets: [CachedWallet] = []
    @Published private(set) var loading: Bool = false
    
    private let walletStorage = CachedWalletStorage.shared
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    // MARK: - Initialization
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        walletStorage.$list
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .assign(to: &$wallets)
    }
    
    
    // MARK: - Public Methods
    
    func sync() async {
        await wallets.asyncForEach { wallet in
            guard let address = wallet.address else { return }
            let syncProvider = SyncProvider(address: address)
            await syncProvider.parse()
            await syncProvider.sync()
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            do {
                guard let itemToDelete = (index > wallets.count ? nil : wallets[index]) else { return }
                try CachedWalletStorage.shared.delete(object: itemToDelete)
            } catch {
                print("⚠️ \(error)")
            }
        }
    }
    
    
    func dismiss() {
        self.shouldDismissView = true
    }

}
