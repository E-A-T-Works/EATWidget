//
//  AssetSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import Foundation
import Combine


@MainActor
final class AssetSheetViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var loading: Bool = true
    @Published private(set) var asset: Asset? = nil
    
    @Published private(set) var backgroundColor: Color = .clear
    @Published private(set) var foregroundColor: Color = .black
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Public Methods
    
    func dismiss() {
        shouldDismissView = true
    }
    
    // MARK: API Handlers
    
    func load(contractAddress: String, tokenId: String) {
        Task {
            do {
                self.loading = true
                
                self.asset = try await AssetProvider.fetchAsset(contractAddress: contractAddress, tokenId: tokenId)
                resolveColors()
                
                self.loading = false
            } catch {
                print("⚠️ (AssetPageViewModel)::load() \(error)")
            }
        }

    }
    
    private func resolveColors()  {
        let derivedColors = Theme.resolveColorsFromImage(
            imageUrl: asset?.imageUrl,
            preferredBackgroundColor: asset?.backgroundColor
        )
        backgroundColor = Color(uiColor: derivedColors.backgroundColor)
        foregroundColor = Color(uiColor: derivedColors.foregroundColor)
    }

}
