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
        
        let newWallet = NFTWallet(context: viewContext)
        newWallet.address = TestData.nft.address
        newWallet.title = "Test Wallet"
        newWallet.timestamp = Date()
        
        let newNFTObject = NFTObject(context: viewContext)
        
        newNFTObject.address = TestData.nft.address
        newNFTObject.tokenId = TestData.nft.tokenId
        newNFTObject.standard = TestData.nft.standard
        newNFTObject.title = TestData.nft.title
        newNFTObject.text = TestData.nft.text

        let newNFTImage = NFTImage(context: viewContext)
        newNFTImage.blob = TestData.nft.image.jpegData(compressionQuality: 1.0)
        
        newNFTObject.image = newNFTImage
        newNFTObject.simulationUrl = TestData.nft.simulationUrl
        newNFTObject.animationUrl = TestData.nft.animationUrl
        
        newNFTObject.discordUrl = TestData.nft.discordUrl
        newNFTObject.twitterUrl = TestData.nft.twitterUrl
        newNFTObject.externalUrl = TestData.nft.externalUrl
        newNFTObject.metadataUrl = TestData.nft.metadataUrl
        
        newNFTObject.attributes = []
        
        newNFTObject.wallet = newWallet
        
        newNFTObject.timestamp = Date()
        
        
        
        
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
