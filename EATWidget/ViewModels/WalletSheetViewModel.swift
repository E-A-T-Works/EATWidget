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

enum WalletSheetContent {
    case MailForm(data: ComposeMailData)
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
    
    @Published private(set) var supported: [NFT] = []
    
    @Published var sheetContent: WalletSheetContent = .MailForm(
        data: ComposeMailData(
            subject: "[BETA:EATWidget] - Missing NFT",
            recipients: ["adrian@eatworks.xyz"],
            message: "Please provide the contract address and token Id (or a link that has that info e.g. opensea) for each NFT you think should be supported.",
            attachments: []
        )
    )
    
    @Published var showingError: Bool = false
    @Published var showingSheet: Bool = false
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Public Methods
    
    func presentMailFormSheet() {
        showingSheet.toggle()
    }
    
    func updateTitle(_ newValue: String) {
        guard !(newValue.count > 50) else {
            return // Titles should not be more than 50 characters long
        }
        
        form.title = newValue
        updateFormValidity()
    }
    
    func load(address: String) {
        Task {
            guard let wallet = (NFTWalletStorage.shared.fetch().first {
                $0.address == address
            }) else {
                self.error = true
                return
            }
            
            self.wallet = wallet
            
            self.form.address = wallet.address!
            self.form.title = wallet.title ?? ""

            self.error = false
            
            self.lookup()
        }
    }
    
    func lookup() {
        Task {
            do {
                self.loading = true
                
                self.supported = try await NFTProvider.fetchNFTs(
                    ownerAddress: form.address,
                    strategy: .Alchemy
                )
                
                self.loading = false
                
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
                
                // update the wallet
                let wallet = try NFTWalletStorage.shared.update(
                    title: form.title.isEmpty ? nil : form.title,
                    object: wallet!
                )
                
                // sync the data NFTs in the wallet
                try await NFTObjectStorage.shared.sync(
                    list: supported,
                    wallet: wallet
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
