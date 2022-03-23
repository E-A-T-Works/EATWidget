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
    
    @Published private(set) var prog: [NFTParseTaskState] = [NFTParseTaskState]()
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
                state: .pending,
                raw: result,
                parsed: nil
            )
        }
        
        isLoading = false
    }
    
    func process() async {
        print("⚙️ process()")
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
        DispatchQueue(label: "xyz.eatworks.app.workers", qos: .userInitiated).async { [weak self] in
            
            self?.queue.waitUntilAllOperationsAreFinished()

            DispatchQueue.main.async { [weak self] in
                print("🎉🎉🎉🎉🎉🎉🎉🎉")
                self?.isProcessing = false
            }
        }
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
    
    func reset() {
        updateAddress("")
        updateTitle("")

        isAddressSet = false
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
