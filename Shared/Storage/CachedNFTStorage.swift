//
//  CachedNFTStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/22/22.
//

import Foundation
import Combine
import CoreData
import UIKit


final class CachedNFTStorage: NSObject, ObservableObject {
    
    static let shared: CachedNFTStorage = CachedNFTStorage()
    
    @Published var list: [CachedNFT] = [CachedNFT]()
    
    
    private let fetchRequest: NSFetchRequest<CachedNFT>
    private let fetchedResultsController: NSFetchedResultsController<CachedNFT>
    
    private let persistenceController = PersistenceController.shared
    
    private override init() {
        fetchRequest = CachedNFT.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \CachedNFT.address, ascending: false)
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
    
    
    
    func fetch() -> [CachedNFT] {
        var list: [CachedNFT] {
            do {
                try fetchedResultsController.performFetch()
                return fetchedResultsController.fetchedObjects ?? [CachedNFT]()
            } catch {
                print("⚠️ \(error)")
                return [CachedNFT]()
            }
        }
        
        return list
    }
    
    func sync(wallet: CachedWallet, list: [NFT]) throws -> [CachedNFT] {
    
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
            
            guard let imageBlob = data.image.jpegData(compressionQuality: 1.0) else { return }
            
            let cachedImage = CachedImage(context: context)
            cachedImage.blob = imageBlob
            
            
            let newObject = CachedNFT(context: context)
            newObject.address = data.address
            newObject.tokenId = data.tokenId

            newObject.title = data.title
            newObject.text = data.text

            newObject.image = cachedImage
            newObject.animationUrl = data.animationUrl
            newObject.simulationUrl = data.simulationUrl
            
            newObject.openseaUrl = data.openseaUrl

            newObject.externalUrl = data.externalUrl
            newObject.metadataUrl = data.metadataUrl
                        
            newObject.wallet = wallet

            newObject.timestamp = Date()
            
            
            data.attributes.forEach { attribute in

                let newAttribute = CachedAttribute(context: context)
                newAttribute.key = attribute.key
                newAttribute.value = attribute.value

                newAttribute.nft = newObject
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
            
            let update = list.first { $0.address == cached.address && $0.tokenId == cached.tokenId }
            guard update != nil else { return }
            
            guard let imageBlob = update!.image.jpegData(compressionQuality: 1.0) else { return }
            
            let cachedImage = CachedImage(context: context)
            cachedImage.blob = imageBlob

            cached.title = update!.title
            cached.text = update!.text
            
            cached.image = cachedImage
            cached.animationUrl = update!.animationUrl
            cached.simulationUrl = update!.simulationUrl

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

extension CachedNFTStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [CachedNFT] else { return }

        self.list = list
    }
}

