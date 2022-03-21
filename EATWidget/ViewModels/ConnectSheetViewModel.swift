//
//  ConnectSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//


import Foundation
import Combine
import UIKit


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
    
    @Published private(set) var addressIsSet: Bool = true
    @Published private(set) var loading: Bool = false
    
    @Published private(set) var rawResults: [APIAlchemyNFT] = [APIAlchemyNFT]()
    @Published private(set) var cleanedResults: [DataFetchResultKey: [NFT]] = [
        .Supported: [NFT](),
        .Unsupported: [NFT]()
    ]
    @Published private(set) var totalResults: Int = 0
    @Published private(set) var totalCleaned: Int = 0
    
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
    
    
    private let walletStorage = NFTWalletStorage.shared
    private let objectStorage = NFTObjectStorage.shared
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
  
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Public Methods
    
    func reset() {
        updateAddress("")
        updateTitle("")

        addressIsSet = false
    }
    
    
    // MARK: -
    
    func updateAddress(_ newValue: String) {
        form.address = newValue
        updateFormValidity()
    }

    func validateAddress(_ addressToTest: String) -> Bool {
        // ref: https://info.etherscan.com/what-is-an-ethereum-address/
        
//        let lengthCheck = addressToTest.count == 42
//        let prefixCheck = addressToTest.hasPrefix("0x")
//
//        return lengthCheck && prefixCheck
        return true
    }
    
    func setAddressFromPasteboard() {
        let pasteboard = UIPasteboard.general
        guard let address = pasteboard.string else { return }
        
        updateAddress(address)
        lookup()
    }

    func updateTitle(_ newValue: String) {
        guard !(newValue.count > 50) else {
            return // Titles should not be more than 50 characters long
        }
        
        form.title = newValue
        updateFormValidity()
    }
    
    func validateTitle(_ titleToTest: String) -> Bool {
        return true
    }

    
    // MARK: -
    
    func lookup() {
        
        print("🔍 lookup() \(form.address)")
        
        guard form.isValid else {
            
            print("🙅‍♂️ Invalid: \(form.address) \(form.title)")
            
            return
        }
        
        loading = true
        addressIsSet = true
        
        Task {

            do {
//                results = try await NFTProvider.fetchNFTs(
//                    ownerAddress: form.address,
//                    strategy: .Alchemy
//                )
                
//                print()
                
//                print("➡️ Supported: \(results[.Supported]?.count ?? 0) | Unsupported: \(results[.Unsupported]?.count ?? 0)")
                
//                print()
                
                
                rawResults = try await APIAlchemyProvider.fetchNFTs(ownerAddress: form.address)
                
            } catch {
                print("⚠️ (ConnectSheetViewModel)::load() \(error)")
            }
            
            print("✅")
            loading = false
        }
    }
    
    func submit() {
//        Task {
//            do {
//                // add the wallet
//                let wallet = try walletStorage.create(
//                    address: form.address,
//                    title: form.title.isEmpty ? nil : form.title
//                )
//
//                // sync the data NFTs in the wallet
//                try await objectStorage.sync(
//                    list: supported,
//                    wallet: wallet
//                )
//
//                dismiss()
//            } catch {
//                print("⚠️ (ConnectSheetViewModel)::submit() \(error)")
//            }
//        }
    }
    
    func dismiss() {
        self.shouldDismissView = true
    }
    
    // MARK: -

    func presentMailFormSheet() {
        sheetContent = .MailForm(
            data: ComposeMailData(
                subject: "[BETA:EATWidget] - Missing NFT",
                recipients: ["adrian@eatworks.xyz"],
                message: "(Wallet Address: \(form.address)) Please provide the contract address and token Id (or a link that has that info e.g. opensea) for each NFT you think should be supported.",
                attachments: []
            )
        )
        showingSheet.toggle()
    }
    
    // MARK: - Private Methods
    
    private func updateFormValidity() {
        form.isValid = isValidForm()
    }
    
    private func isValidForm() -> Bool {
        return !form.address.isEmpty && validateAddress(form.address) && validateTitle(form.title)
    }
}
