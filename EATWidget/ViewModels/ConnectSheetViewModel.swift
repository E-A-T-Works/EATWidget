//
//  ConnectSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//


import Foundation
import Combine


struct ConnectFormState: Equatable {
    var title: String = ""
    var address: String = ""
    
    var isValid: Bool = false
}


@MainActor
final class ConnectSheetViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var form: ConnectFormState
    @Published private(set) var canAddWallet: Bool = false
    
    @Published private(set) var ready: Bool = true
    @Published private(set) var loading: Bool = false
    
    @Published private(set) var supported: [NFT] = []
    @Published private(set) var unsupported: [NFT] = []
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
  
    // MARK: - Initialization
    
    init(initialFormState: ConnectFormState) {
        self.form = initialFormState
    }
    
    // MARK: - Public Methods
    
    func updateTitle(_ newValue: String) {
        guard !(newValue.count > 50) else {
            return // Titles should not be more than 50 characters long
        }
        
        form.title = newValue
        updateFormValidity()
    }
    
    func updateAddress(_ newValue: String) {
        form.address = newValue
        updateFormValidity()
    }
    
    func load() {
        ready = true

        Task {
            do {
                self.loading = true
                
                let results = try await NFTProvider.fetchNFTs(
                    ownerAddress: form.address,
                    strategy: .Alchemy,
                    syncCache: false,
                    filterOutUnsupported: false
                )
                
                for item in results {
                    print([item.address, item.imageUrl ?? "IDK"])
                }
                
                self.supported = results.filter { $0.isSupported }
                self.unsupported = results.filter { !$0.isSupported }
                
                self.loading = false
                
            } catch {
                print("⚠️ (ConnectSheetViewModel)::load() \(error)")
                self.loading = false
            }
        }
    }
    
    func submit() {
        do {
            try WalletStorage.shared.add(
                address: form.address,
                title: form.title
            )
            
            self.shouldDismissView = true
        } catch {
            print("⚠️ (ConnectSheetViewModel)::submit() \(error)")
        }
    }
    
    
    
    // MARK: - Private Methods
    
    private func updateFormValidity() {
        form.isValid = isValidForm()
    }
    
    private func isValidForm() -> Bool {
        return !form.address.isEmpty
    }
}
