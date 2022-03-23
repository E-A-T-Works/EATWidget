//
//  ConnectSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//


import Foundation
import Combine
import UIKit


// MARK: - ViewModel

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
    
    @Published private(set) var list: [NFTParseTask] = [NFTParseTask]()
    @Published private(set) var totalCount: Int = 0
    @Published private(set) var parsedCount: Int = 0
    @Published private(set) var successCount: Int = 0
    @Published private(set) var failureCount: Int = 0
    
    @Published var sheetContent: ConnectSheetSheetContent = .MailForm(
        data: ComposeMailData(
            subject: "[BETA:EATWidget] - App Feedback",
            recipients: ["adrian@eatworks.xyz"],
            message: "Thank you for sharing your feedback, let us know what we can improve...",
            attachments: []
        )
    )
    
    @Published var showingSheet: Bool = false
    @Published var showingLoader: Bool = false
    @Published var showingError: Bool = false
    
    private let queue = OperationQueue()
    
    
    private let walletStorage = NFTWalletStorage.shared
    private let objectStorage = NFTObjectStorage.shared
    private let api: APIAlchemyProvider = APIAlchemyProvider.shared
    
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
  
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Form Submission and Lookup
 
    func lookup() async {
        
        guard form.isValid else {
            showingError = true
            return
        }
        
        isAddressSet = true
        isLoading = true
        
        let address = form.address
        
        var results: [APIAlchemyNFT] = [APIAlchemyNFT]()
    
        do {
            results = try await api.getNFTs(for: address)
        } catch {
            print("⚠️ \(error)")
        }
        
        totalCount = results.count
        
        list = results.map { result in
            let address = result.contract.address
            let tokenId = result.id.tokenId
            let key = "\(address)/\(tokenId)"
            
            return NFTParseTask(
                id: key,
                address: address,
                tokenId: tokenId,
                state: .pending,
                raw: result,
                parsed: nil
            )
        }
        
        isLoading = false
    }
    
    func process() async {
        isProcessing = true
        
        list.indices.forEach { index in
            let data = list[index]
            
            let parseOp = ParseNFTOperation(data: data.raw)

            parseOp.completionBlock = {
                DispatchQueue.main.async {
                    
                    let parsed = parseOp.parsed
                    
                    
                    var data = self.list[index]
                    data.state = parsed == nil ? .failure : .success
                    data.parsed = parseOp.parsed
                    
                    self.list[index] = data
                    
                    self.parsedCount += 1
                    
                    if parsed == nil {
                        self.failureCount += 1
                    } else {
                        self.successCount += 1
                    }
                    
                    
                }
            }

            queue.addOperation(parseOp)
        }
        
        // wait for everything to finish
        DispatchQueue(label: "xyz.eatworks.app.worker", qos: .userInitiated).async { [weak self] in
            
            self?.queue.waitUntilAllOperationsAreFinished()

            DispatchQueue.main.async { [weak self] in
                self?.isProcessing = false
            }
        }
    }
    
    func submit() async {
        showingLoader = true

        let toCache: [NFT] = list.filter { $0.state == .success }.map { $0.parsed }.compactMap { $0 }
        
        guard !toCache.isEmpty else {
            showingLoader = false
            return
        }
        
        do {
            let wallet = try walletStorage.set(
                address: form.address,
                title: form.title
            )
            
            try objectStorage.sync(
                wallet: wallet,
                list: toCache
            )
            
            // TODO: Dismiss

        } catch {
            showingLoader = false
            return
        }
        
        
        
        
        showingLoader = false
    }
    
    func lookupAndProcess() async {
        await lookup()
        await process()
    }
    
    func setAddressFromPasteboard() {
        let pasteboard = UIPasteboard.general
        guard let address = pasteboard.string else { return }
        
        updateAddress(address)
        Task { await lookupAndProcess() }
    }
    
    func reset() {
        form = ConnectSheetFormState(
            title: "",
            address: "",
            isValid: false
        )

        isAddressSet = false
        isLoading = false
        isProcessing = false
        
        list = [NFTParseTask]()
        totalCount = 0
        parsedCount = 0
        successCount = 0
        failureCount = 0
    }
    

    // MARK: - Overlay Helpers

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
    
    func presentAlert() {
        
        showingError.toggle()
    }
    
    func dismiss() {
        self.shouldDismissView = true
    }
    
    
    
    // MARK: - Form Field Helpers
    
    func updateAddress(_ newValue: String) {
        form.address = newValue
        updateFormValidity()
    }

    func updateTitle(_ newValue: String) {
        guard !(newValue.count > 50) else {
            return // Titles should not be more than 50 characters long
        }
        
        form.title = newValue
        updateFormValidity()
    }

    
    
    // MARK: - Validity Helpers
    
    private func updateFormValidity() {
        form.isValid = isValidForm()
    }
    
    private func isValidForm() -> Bool {
        return !form.address.isEmpty && validateAddress(form.address) && validateTitle(form.title)
    }
    
    func validateAddress(_ addressToTest: String) -> Bool {
        // ref: https://info.etherscan.com/what-is-an-ethereum-address/
        
        let lengthCheck = addressToTest.count <= 42

        return lengthCheck
    }
    
    func validateTitle(_ titleToTest: String) -> Bool {
        return true
    }
}


// MARK: - Auxillary

struct ConnectSheetFormState: Equatable {
    var title: String = ""
    var address: String = ""
    
    var isValid: Bool = false
}

struct ConnectSheetError {
    var title: String = ""
    var text: String = ""
}

enum ConnectSheetSheetContent {
    case MailForm(data: ComposeMailData)
}
