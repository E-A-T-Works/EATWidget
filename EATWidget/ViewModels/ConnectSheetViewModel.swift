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

enum ConnectFormSheetContent {
    case MailForm(data: ComposeMailData)
}

@MainActor
final class ConnectSheetViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var form: ConnectFormState = ConnectFormState(
        title: "",
        address: ""
    )
    
    @Published private(set) var ready: Bool = false
    @Published private(set) var loading: Bool = false
    
    @Published private(set) var supported: [NFT] = []
    
    @Published var sheetContent: ConnectFormSheetContent = .MailForm(
        data: ComposeMailData(
            subject: "[BETA:EATWidget] - App Feedback",
            recipients: ["adrian@eatworks.xyz"],
            message: "Thank you for sharing your feedback, let us know what we can improve...",
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
    
    func resetAddress() {
        updateAddress("")
        supported = []
    }
    
    func validateAddress(_ addressToTest: String) -> Bool {
        // ref: https://info.etherscan.com/what-is-an-ethereum-address/
        
        let lengthCheck = addressToTest.count == 42
        let prefixCheck = addressToTest.hasPrefix("0x")
        
        return lengthCheck && prefixCheck
    }
    
    
    func presentMailFormSheet() {
        sheetContent = .MailForm(
            data: ComposeMailData(
                subject: "[BETA:EATWidget] - Missing NFT",
                recipients: ["adrian@eatworks.xyz"],
                message: "Please provide the contract address and token Id (or a link that has that info e.g. opensea) for each NFT you think should be supported.",
                attachments: []
            )
        )
        showingSheet.toggle()
    }
    
    func lookup() {
        ready = true

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
                // add the wallet
                let wallet = try NFTWalletStorage.shared.create(
                    address: form.address,
                    title: form.title.isEmpty ? nil : form.title
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
