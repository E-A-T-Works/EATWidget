//
//  NFTSheetViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import Foundation
import Combine


@MainActor
final class NFTSheetViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published private(set) var loading: Bool = true
    
    @Published private(set) var nft: NFT? = nil
    

    @Published private(set) var traits: [NFTTrait] = []
    
    
    @Published private(set) var imageUrl: URL =  Bundle.main.url(forResource: "Placeholder", withExtension: "png")!
    @Published private(set) var actionButtons: [ActionRowButton] = []
    @Published private(set) var paymentTokens: [String] = []
    
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
                
                self.nft = try await NFTProvider.fetchNFT(contractAddress: contractAddress, tokenId: tokenId)
                
                resolveImageUrl()
                resolveColors()
                resolveActionButtons()
                resolvePaymentTokens()
                resolveTraits()
                
                self.loading = false
            } catch {
                print("⚠️ (AssetPageViewModel)::load() \(error)")
            }
        }

    }
    
    private func resolveImageUrl() -> Void {
//        imageUrl = nft?.imageUrl ?? nft?.thumbnailUrl ?? Bundle.main.url(forResource: "eat-b-w-0", withExtension: "png")!
    }
    
    private func resolveColors() -> Void {
//        let derivedColors = Theme.resolveColorsFromImage(
//            imageUrl: nft?.imageUrl,
//            preferredBackgroundColor: nil
//        )
//        backgroundColor = Color(uiColor: derivedColors.backgroundColor)
//        foregroundColor = Color(uiColor: derivedColors.foregroundColor)
    }
    
    private func resolveActionButtons() -> Void {
//        var buttonsToSet = [ActionRowButton]()
//
//        if nft == nil {
//            actionButtons = buttonsToSet
//            return
//        }
//
//        buttonsToSet.append(
//            ActionRowButton(
//                target: .Opensea,
//                url: URL(string: "https://opensea.io/assets/\(nft!.address)/\(nft!.tokenId)")!
//            )
//        )
    
        
//        if nft?.collection?.twitterUrl != nil {
//            buttonsToSet.append(
//                ActionRowButton(
//                    target: .Twitter,
//                    url: (nft?.collection?.twitterUrl!)!
//                )
//            )
//        }
//
//        if nft?.collection?.discordUrl != nil {
//            buttonsToSet.append(
//                ActionRowButton(
//                    target: .Discord,
//                    url: (nft?.collection?.discordUrl!)!
//                )
//            )
//        }
        
        
//        actionButtons = buttonsToSet
    }
    
    private func resolvePaymentTokens() -> Void {
        paymentTokens = []
    }

    private func resolveTraits() -> Void {
        traits = nft?.traits ?? []
    }
}
