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
    
    @Published var form: ConnectFormState
    @Published private(set) var canAddWallet: Bool = false
    
    @Published private(set) var ready: Bool = false
    @Published private(set) var loading: Bool = false
    
    @Published private(set) var supported: [NFT] = []
    @Published private(set) var unsupported: [NFT] = []
    
    @Published var sheetContent: ConnectFormSheetContent = .MailForm(
        data: ComposeMailData(
            subject: "[BETA:EATWidget] - App Feedback",
            recipients: ["adrian@eatworks.xyz"],
            message: "Thank you for sharing your feedback, let us know what we can improve...",
            attachments: []
        )
    )
    @Published var showingSheet: Bool = false
    
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
                
                self.supported = results.filter { $0.isSupported }
                self.unsupported = results.filter { !$0.isSupported }
                
                self.canAddWallet = !self.supported.isEmpty
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
