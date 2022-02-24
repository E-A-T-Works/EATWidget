//
//  WalletSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import Foundation
import Combine


struct WalletFormState: Equatable {
    var title: String = ""
    var address: String = ""

    var isValid: Bool = false
}

@MainActor
final class WalletSheetViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var form: WalletFormState = WalletFormState(
        title: "",
        address: "",
        isValid: true
    )
    
    
    @Published private(set) var loading: Bool = false
    @Published private(set) var error: Bool = false
    
    @Published private(set) var wallet: NFTWallet?
    
    @Published private(set) var loadingNFTs: Bool = false
    @Published private(set) var supported: [NFT] = []
    
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Public Methods
    
    func updateTitle(_ newValue: String) {
        guard !(newValue.count > 50) else {
            return // Titles should not be more than 50 characters long
        }
        
        form.title = newValue
        updateFormValidity()
    }
    
    func load(address: String) {
        Task {
            self.loading = true
            
            guard let wallet = (NFTWalletStorage.shared.fetch().first {
                $0.address == address
            }) else {
                self.error = true
                self.loading = false
                return
            }
            
            self.wallet = wallet
            
            self.form.address = wallet.address!
            self.form.title = wallet.title ?? ""

            self.error = false
            self.loading = false
            
            self.lookup()
        }
    }
    
    func lookup() {
        Task {
            do {
                self.loadingNFTs = true
                
                self.supported = try await NFTProvider.fetchNFTs(
                    ownerAddress: form.address,
                    strategy: .Alchemy
                )
                
                self.loadingNFTs = false
                
            } catch {
                print("⚠️ (ConnectSheetViewModel)::load() \(error)")

                self.loading = false
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        supported.remove(atOffsets: offsets)
    }
    
    
    func submit() {
        Task {
            do {
                
                // add the wallet
                let updatedWallet = try NFTWalletStorage.shared.update(
                    title: form.title.isEmpty ? nil : form.title,
                    object: wallet!
                )
                
                // sync the data NFTs in the wallet
                try await NFTObjectStorage.shared.sync(
                    list: supported,
                    wallet: updatedWallet
                )
                            
                dismiss()
                
            } catch {
                print("⚠️ (ConnectSheetViewModel)::submit() \(error)")
            }
        }
    }
    
    func dismiss() {
        self.shouldDismissView = true
    }
    
    // MARK: - Private Methods
    
    private func updateFormValidity() {
        form.isValid = isValidForm()
    }
    
    private func isValidForm() -> Bool {
        return !form.address.isEmpty
    }
}
