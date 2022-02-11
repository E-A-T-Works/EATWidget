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
    
    @Published private(set) var imageUrl: URL =  Bundle.main.url(forResource: "Placeholder", withExtension: "png")!
    @Published private(set) var actionButtons: [AssetSheetActionButtons] = []
    
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
                
                resolveImageUrl()
                resolveColors()
                resolveActionButtons()
                
                self.loading = false
            } catch {
                print("⚠️ (AssetPageViewModel)::load() \(error)")
            }
        }

    }
    
    private func resolveImageUrl() -> Void {
        if(asset?.imageUrl != nil) {
            self.imageUrl = (asset?.imageUrl!)!
        } else if(asset?.imageThumbnailUrl != nil) {
            self.imageUrl = (asset?.imageThumbnailUrl!)!
        } else {
            self.imageUrl = Bundle.main.url(forResource: "Placeholder", withExtension: "png")!
        }
    }
    
    private func resolveColors() -> Void {
        let derivedColors = Theme.resolveColorsFromImage(
            imageUrl: asset?.imageUrl,
            preferredBackgroundColor: asset?.backgroundColor
        )
        backgroundColor = Color(uiColor: derivedColors.backgroundColor)
        foregroundColor = Color(uiColor: derivedColors.foregroundColor)
    }
    
    private func resolveActionButtons() -> Void {
        var buttonsToSet = [AssetSheetActionButtons]()
        
        if asset?.permalink != nil {
            buttonsToSet.append(
                AssetSheetActionButtons(
                    target: .Opensea,
                    url: (asset?.permalink!)!
                )
            )
        }
        
        if asset?.collection?.twitterUrl != nil {
            buttonsToSet.append(
                AssetSheetActionButtons(
                    target: .Twitter,
                    url: (asset?.collection?.twitterUrl!)!
                )
            )
        }
        
        if asset?.collection?.discordUrl != nil {
            buttonsToSet.append(
                AssetSheetActionButtons(
                    target: .Discord,
                    url: (asset?.collection?.discordUrl!)!
                )
            )
        }
        
        
        actionButtons = buttonsToSet
    }

}
