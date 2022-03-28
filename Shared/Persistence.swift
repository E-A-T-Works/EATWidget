//
//  Persistence.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        
        // TODO: Load up some test data for previews
        
        let viewContext = result.container.viewContext
        
        let newWallet = CachedWallet(context: viewContext)
        newWallet.address = TestData.nft.address
        newWallet.title = "Test Wallet"
        newWallet.timestamp = Date()
        
        let newNFT = CachedNFT(context: viewContext)
        
        newNFT.address = TestData.nft.address
        newNFT.tokenId = TestData.nft.tokenId
        newNFT.standard = TestData.nft.standard
        newNFT.title = TestData.nft.title
        newNFT.text = TestData.nft.text

        let newImage = CachedImage(context: viewContext)
        newImage.blob = TestData.nft.image.jpegData(compressionQuality: 1.0)
        
        newNFT.image = newImage
        newNFT.simulationUrl = TestData.nft.simulationUrl
        newNFT.animationUrl = TestData.nft.animationUrl
        
        newNFT.discordUrl = TestData.nft.discordUrl
        newNFT.twitterUrl = TestData.nft.twitterUrl
        newNFT.externalUrl = TestData.nft.externalUrl
        newNFT.metadataUrl = TestData.nft.metadataUrl
        
        newNFT.attributes = []
        
        newNFT.wallet = newWallet
        
        newNFT.timestamp = Date()
        
        
        
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "EATWidget")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else{
            let storeURL = AppGroup.base.containerURL.appendingPathComponent("EATWidget.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [description]
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("⚠️ Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
