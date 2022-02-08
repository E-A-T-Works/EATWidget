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

// MARK: BasicAssetOptions

extension IntentHandler: BasicAssetOptionsIntentHandling {
    func provideWalletOptionsCollection(for intent: BasicAssetOptionsIntent) async throws -> INObjectCollection<WalletINO> {
        
        do {
            return try await DynamicIntentHelpers.provideWalletOptionsCollection()
        } catch {
            print("⚠️ (IntentHandler:BasicAssetOptionsIntentHandling)::provideWalletOptionsCollection() \(error)")
            return INObjectCollection(items: [WalletINO]())
        }
        
    }
    
    func provideAssetOptionsCollection(for intent: BasicAssetOptionsIntent) async throws -> INObjectCollection<AssetINO> {
        
        do {
            return try await DynamicIntentHelpers.provideAssetOptionsCollection(walletId: intent.Wallet?.identifier)
        } catch {
            print("⚠️ (IntentHandler:BasicAssetOptionsIntentHandling)::provideAssetOptionsCollection() \(error)")
            return INObjectCollection(items: [AssetINO]())
        }
        
    }
}


// MARK: RandomAssetOptions

extension IntentHandler: RandomAssetOptionsIntentHandling {
    func provideWalletOptionsCollection(for intent: RandomAssetOptionsIntent) async throws -> INObjectCollection<WalletINO> {
        
        do {
            return try await DynamicIntentHelpers.provideWalletOptionsCollection()
        } catch {
            print("⚠️ (IntentHandler:RandomAssetOptionsIntentHandling)::provideWalletOptionsCollection() \(error)")
            return INObjectCollection(items: [WalletINO]())
        }
        
    }
}
