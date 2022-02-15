//
//  DynamicIntentHelpers.swift
//  ConfigurationIntents
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Intents


final class DynamicIntentHelpers {
    
    static func provideWalletOptionsCollection() async throws -> INObjectCollection<WalletINO> {
        let wallets = WalletStorage.shared.fetch()
        
        let items: [WalletINO] = wallets.map { wallet in
            return WalletINO(
                identifier: wallet.address,
                display: wallet.title != nil && !wallet.title!.isEmpty ? wallet.title! : "Untitled Wallet",
                subtitle: wallet.address,
                image: nil
            )
        }

        return INObjectCollection(items: items)
    }
    
    static func provideNFTOptionsCollection(walletId: String?) async throws -> INObjectCollection<NFTINO> {
        let wallets = WalletStorage.shared.fetch()

        var wallet: Wallet?
        if walletId != nil {
            wallet = wallets.first { $0.id == walletId } ?? wallets.first
        }else{
            wallet = wallets.first
        }
        
        let address = wallet?.address
        
        if address == nil {
            return INObjectCollection(items: [NFTINO]())
        }
        
        let options = NFTOptionStorage.shared.fetch()
        
        ///
        /// TODO: There is something broken with how iOS renders
        /// the image on the Widget Intent Controller
        ///
        /// ref: https://developer.apple.com/documentation/sirikit/inimage/
        /// ref: https://developer.apple.com/forums/thread/660141
        /// ref: https://stackoverflow.com/questions/70979943/widgetkit-dynamic-intent-selection-is-missing-image
        /// ref: https://github.com/hackenbacker/FictionalCard/issues/1
        ///
        
        let items: [NFTINO] = options.filter { item in
            item.wallet?.address == address
        }.map { item in
            return NFTINO(
                identifier: item.identifier,
                display: item.display ?? "Untitled",
                subtitle: item.subtitle,
                image: item.imageUrl != nil ? INImage(url: item.imageUrl!) : nil
            )
        }

        return INObjectCollection(items: items)

    }
}

