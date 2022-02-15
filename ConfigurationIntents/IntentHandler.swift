//
//  IntentHandler.swift
//  ConfigurationIntents
//
//  Created by Adrian Vatchinsky on 2/8/22.
//
//  References:
//      https://medium.com/swlh/build-your-first-ios-widget-part-3-36ba53033e33
//      https://stackoverflow.com/questions/65109056/widgetkit-customize-intent-parameters-selection
//      https://stackoverflow.com/questions/38093871/how-do-i-debug-my-siri-intents-extension
//      https://stackoverflow.com/questions/66020214/widgets-intenthandler-parameters-with-dynamic-options-dependent-on-other-paramet
//


import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}



// MARK: WalletOptions

extension IntentHandler: WalletOptionsIntentHandling {
    func provideWalletOptionsCollection(for intent: WalletOptionsIntent) async throws -> INObjectCollection<WalletINO> {
        
        do {
            return try await DynamicIntentHelpers.provideWalletOptionsCollection()
        } catch {
            print("⚠️ (IntentHandler:WalletOptionsIntentHandling)::provideWalletOptionsCollection() \(error)")
            return INObjectCollection(items: [WalletINO]())
        }
        
    }
}

// MARK: BasicNFTOptions

extension IntentHandler: BasicNFTOptionsIntentHandling {
    func provideWalletOptionsCollection(for intent: BasicNFTOptionsIntent) async throws -> INObjectCollection<WalletINO> {
        
        do {
            return try await DynamicIntentHelpers.provideWalletOptionsCollection()
        } catch {
            print("⚠️ (IntentHandler:BasicNFTOptionsIntentHandling)::provideWalletOptionsCollection() \(error)")
            return INObjectCollection(items: [WalletINO]())
        }
        
    }
    
    func provideNFTOptionsCollection(for intent: BasicNFTOptionsIntent) async throws -> INObjectCollection<NFTINO> {
        
        do {
            return try await DynamicIntentHelpers.provideNFTOptionsCollection(walletId: intent.Wallet?.identifier)
        } catch {
            print("⚠️ (IntentHandler:BasicNFTOptionsIntentHandling)::provideNFTOptionsCollection() \(error)")
            return INObjectCollection(items: [NFTINO]())
        }
        
    }
}


// MARK: RandomNFTOptions

extension IntentHandler: RandomNFTOptionsIntentHandling {
    func provideWalletOptionsCollection(for intent: RandomNFTOptionsIntent) async throws -> INObjectCollection<WalletINO> {
        
        do {
            return try await DynamicIntentHelpers.provideWalletOptionsCollection()
        } catch {
            print("⚠️ (IntentHandler:RandomNFTOptionsIntentHandling)::provideWalletOptionsCollection() \(error)")
            return INObjectCollection(items: [WalletINO]())
        }
        
    }
}
