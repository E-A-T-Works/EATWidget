//
//  NFTObjectStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/22/22.
//

import Foundation
import Combine
import CoreData
import UIKit


final class NFTObjectStorage: NSObject, ObservableObject {
    
    static let shared: NFTObjectStorage = NFTObjectStorage()
    
    
    @Published var list: [NFTObject] = [NFTObject]()
    
    
    private let fetchRequest: NSFetchRequest<NFTObject>
    private let fetchedResultsController: NSFetchedResultsController<NFTObject>
    
    private let persistenceController = PersistenceController.shared
    
    
    
    private override init() {
        fetchRequest = NFTObject.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \NFTObject.address, ascending: false)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistenceController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        list = fetch()
    }
    
    
    
    func fetch() -> [NFTObject] {
        var list: [NFTObject] {
            do {
                try fetchedResultsController.performFetch()
                return fetchedResultsController.fetchedObjects ?? [NFTObject]()
            } catch {
                print("⚠️ \(error)")
                return [NFTObject]()
            }
        }
        
        return list
    }
    
    func sync(wallet: NFTWallet, list: [NFT]) throws -> [NFTObject] {
    
        let context = persistenceController.container.viewContext

        let cached = fetch().filter { $0.wallet?.objectID == wallet.objectID }

        //
        // Handle creation
        //

        let toCreate = list.filter { item in
            let exists = cached.first { $0.address == item.address && $0.tokenId == item.tokenId } != nil
            return !exists
        }

        toCreate.forEach { data in
            
            guard let imageBlob = data.image.jpegData(compressionQuality: 0.25) else { return }
            
            let cachedImage = CachedImage(context: context)
            cachedImage.blob = imageBlob
            
            
            let newObject = NFTObject(context: context)
            newObject.address = data.address
            newObject.tokenId = data.tokenId
            newObject.standard = data.standard

            newObject.title = data.title
            newObject.text = data.text

            newObject.image = cachedImage
            newObject.simulationUrl = data.simulationUrl
            newObject.animationUrl = data.animationUrl

            newObject.twitterUrl = data.twitterUrl
            newObject.discordUrl = data.discordUrl
            newObject.openseaUrl = data.openseaUrl
            newObject.externalUrl = data.externalUrl
            newObject.metadataUrl = data.metadataUrl

            newObject.wallet = wallet

            newObject.timestamp = Date()
            
            
            data.attributes.forEach { attribute in

                let newAttribute = CachedAttribute(context: context)
                newAttribute.key = attribute.key
                newAttribute.value = attribute.value

                newAttribute.object = newObject
            }

            
        }

        //
        // Handle updates
        //

        let toUpdate = cached.filter { item in
            let exists = list.first { $0.address == item.address && $0.tokenId == item.tokenId } != nil
            return exists
        }

        toUpdate.forEach { cached in
            let update = list.first { $0.address == cached.address }
            guard update != nil else { return }

            cached.title = update!.title
            cached.text = update!.text
            
            cached.simulationUrl = update!.simulationUrl
            cached.animationUrl = update!.animationUrl

            cached.twitterUrl = update!.twitterUrl
            cached.discordUrl = update!.discordUrl
            cached.openseaUrl = update!.openseaUrl
            cached.externalUrl = update!.externalUrl
            cached.metadataUrl = update!.metadataUrl
        }


        //
        // Handle deletion
        //

        let toDelete = cached.filter { item in
            let exists = list.first { $0.address == item.address && $0.tokenId == item.tokenId } != nil
            return !exists
        }

        toDelete.forEach { context.delete($0) }

        //
        // Commit
        //

        try context.save()


        return fetch()

    }
    
    private func commit() throws {
        let context = persistenceController.container.viewContext
        try context.save()
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate Extension

extension NFTObjectStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [NFTObject] else { return }

        self.list = list
    }
}

