//
//  AssetPageViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import Combine


@MainActor
final class AssetSheetViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var asset: Asset? = nil

    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Public Methods
    
    
    // MARK: API Handlers
    
    func load(contractAddress: String, tokenId: String) {
        Task {
            do {
                self.asset = try await AssetProvider.fetchAsset(contractAddress: contractAddress, tokenId: tokenId)
            } catch {
                print("⚠️ (AssetPageViewModel)::load() \(error)")
            }
        }

    }
}
