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
    
    @Published private(set) var isSyncing: Bool = false
    
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
    
    func add() {}
    
    func sync() {
        isSyncing = true
        
        DispatchQueue(label: "xyz.eatworks.app.worker", qos: .userInitiated).async {
            
            let queue = OperationQueue()
            let operation = RefreshAppContentsOperation()
            queue.addOperation(operation)

            queue.waitUntilAllOperationsAreFinished()

            DispatchQueue.main.async {
                self.isSyncing = false
            }
            
        }
    }
    
}
