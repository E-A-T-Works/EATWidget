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
    
    @Published private(set) var loading: Bool = true
        
    private var cancellable: AnyCancellable?
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    // MARK: - Initialization
    
    init(
        walletPublisher: AnyPublisher<[NFTWallet], Never> = NFTWalletStorage.shared.list.eraseToAnyPublisher()
    ) {
        cancellable = walletPublisher.sink(receiveValue: { [weak self] wallets in
            self?.wallets = wallets
            self?.loading = false
        })
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
