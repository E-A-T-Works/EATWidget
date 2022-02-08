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
    @Published var canAddWallet: Bool = false
    @Published var assets: [Asset] = []
    
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
        Task {
            do {
                self.assets = try await AssetProvider.fetchAssets(ownerAddress: form.address)
                self.canAddWallet = !self.assets.isEmpty
            } catch {
                print("⚠️ (ConnectSheetViewModel)::load() \(error)")
            }
        }
    }
    
    func submit() {
        print("SUBMIT")
        do {
            try WalletStorage.shared.add(address: form.address, title: form.title)
            
            print("did it")
            
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
