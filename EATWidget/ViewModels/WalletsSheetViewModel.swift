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

    @Published private(set) var wallets: [NFTWallet] = []
    
    @Published private(set) var loading: Bool = false
    
    private let walletStorage = NFTWalletStorage.shared
    
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
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            do {
                guard let itemToDelete = (index > wallets.count ? nil : wallets[index]) else { return }
                try NFTWalletStorage.shared.delete(object: itemToDelete)
            } catch {
                print("⚠️ \(error)")
            }
        }
    }
    

    func dismiss() {
        self.shouldDismissView = true
    }
    
    
}
