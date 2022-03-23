//
//  ConnectSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//


import Foundation
import Combine
import UIKit


struct ConnectSheetFormState: Equatable {
    var title: String = ""
    var address: String = ""
    
    var isValid: Bool = false
}

enum ConnectSheetSheetContent {
    case MailForm(data: ComposeMailData)
}

struct ConnectSheetListItem: Identifiable, Hashable {
    let id: String
    
    let address: String
    let tokenId: String
    
    let state: NFTItemState
}

@MainActor
final class ConnectSheetViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var form: ConnectSheetFormState = ConnectSheetFormState(
        title: "",
        address: ""
    )
    
    @Published private(set) var isAddressSet: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isProcessing: Bool = false
    
    @Published private(set) var apiResultMap: [String: APIAlchemyNFT] = [:]
    @Published private(set) var processedMap: [String: NFT] = [:]
    
    @Published private(set) var list: [ConnectSheetListItem] = [ConnectSheetListItem]()
    

    @Published var sheetContent: ConnectSheetSheetContent = .MailForm(
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

        isAddressSet = false
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
        Task {
            await lookup()
            await process()
        }
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
   
    @Published private(set) var providerState: NFTProviderState = .pending
    @Published private(set) var providerData: [String: NFTProviderData] = [:]
    @Published private(set) var providerIds: [String] = [String]()
    
    private let queue = OperationQueue()
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    
    private var disposables = Set<AnyCancellable>()
    
    func lookup() async {
        print("🔍 lookup()")

        isAddressSet = true
        isLoading = true

        
        providerState = .fetching
        
        var results: [APIAlchemyNFT] = [APIAlchemyNFT]()
    
        do {
            results = try await api.getNFTs(for: form.address)
        } catch {
            print("⚠️ \(error)")
        }
        

        providerData = results.reduce([:], { partialResult, item in
            let address = item.contract.address
            let tokenId = item.id.tokenId
            let key = "\(address)/\(tokenId)"
            
            var updated = partialResult
            updated[key] = NFTProviderData(state: .pending, raw: item, cleaned: nil)

            return updated
        })
        
        providerIds = providerData.keys.map { $0 }

    }
    
    func process() async {
        print("⚙️ process()")
        providerState = .processing
        
        providerIds.forEach { id in
            guard let data = providerData[id] else { return }
            
            print("     ❇️ Start: \(id)")
            let parseOp = ParseNFTOperation(data: data.raw)
            
            parseOp.completionBlock = {
                DispatchQueue.main.async {
                    guard var data = self.providerData[id] else { return }
                    
                    let parsed = parseOp.parsed
                    
                    data.state = parsed == nil ? .failure : .success
                    data.cleaned = parseOp.parsed
                    
                    print("     ✅ Finish: \(id)")
                }
            }
            
            queue.addOperation(parseOp)
        }
        
        DispatchQueue(label: "xyz.eatworks.app.workers", qos: .userInitiated).async { [weak self] in
            
            self?.queue.waitUntilAllOperationsAreFinished()

            DispatchQueue.main.async { [weak self] in
                print("🎉🎉🎉🎉🎉🎉🎉🎉")
                self?.providerState = .pending
            }
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
