//
//  DynamicIntentHelpers.swift
//  ConfigurationIntents
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Intents


final class DynamicIntentHelpers {
    
    static func provideWalletOptionsCollection() async throws -> INObjectCollection<WalletINO> {
        let wallets = NFTWalletStorage.shared.fetch()
        
        let items: [WalletINO] = wallets.map { wallet in
            return WalletINO(
                identifier: wallet.address,
                display: wallet.title ?? wallet.address!,
                subtitle: nil,
                image: nil
            )
        }

        return INObjectCollection(items: items)
    }
    
    static func provideNFTOptionsCollection(ownerAddress: String?) async throws -> INObjectCollection<NFTINO> {
        ///
        /// TODO: There is something broken with how iOS renders
        /// the image on the Widget Intent Controller
        ///
        /// ref: https://developer.apple.com/documentation/sirikit/inimage/
        /// ref: https://developer.apple.com/forums/thread/660141
        /// ref: https://stackoverflow.com/questions/70979943/widgetkit-dynamic-intent-selection-is-missing-image
        /// ref: https://github.com/hackenbacker/FictionalCard/issues/1
        ///
        
        let options = NFTObjectStorage.shared.fetch()
        
        let items: [NFTINO] = options.filter { item in
            ownerAddress == nil ? true : item.wallet?.address == ownerAddress
        }.map { item in
            return NFTINO(
                identifier: "\(item.address!)/\(item.tokenId!)",
                display: (item.title ?? item.tokenId)!,
                subtitle: nil,
//                image: item.imageUrl != nil ? INImage(url: item.imageUrl!) : nil
//                image: nil
                image: INImage(imageData: item.image!.blob!)
            )
            
            
        }

        return INObjectCollection(items: items)

    }
}

