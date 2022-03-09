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
    
    // MARK: - Properties
    
    @Published var list: [NFTObject] = [NFTObject]()
    
    private let fetchRequest: NSFetchRequest<NFTObject>
    private let fetchedResultsController: NSFetchedResultsController<NFTObject>
    
    static let shared: NFTObjectStorage = NFTObjectStorage()
    
    // MARK: - Init
    
    private override init() {
        fetchRequest = NFTObject.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \NFTObject.address, ascending: false)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        list = fetch()
    }
    
    // MARK: - Public
    
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

    func sync(list: [NFT], wallet: NFTWallet) async throws {
        print("!!!!!! sync !!!!!!")
        
        let context = PersistenceController.shared.container.viewContext
                
        ///
        /// Get the relevent cached NFTObjects
        /// TODO: Think about how to make use of the filters here rather than manual filter
        ///
        
        let cached = fetch().filter { $0.wallet!.address == wallet.address }
        
        
        ///
        /// Create entries for the items not already stored
        ///
        
        await list.concurrentForEach { item in
            
            ///
            /// Determine if this NFT already has an entry in the store. If it does, resume, the data should not
            /// change since it's immutable.
            ///

            let entry = cached.first { $0.address == item.address && $0.tokenId == item.tokenId }
            let isUpdating = entry != nil
            
            guard let nftObject = isUpdating ? entry : NFTObject(context: context) else { return }
            
            ///
            /// Convert the UIImage to a blob
            ///

            guard let imageBlob = item.image.jpegData(compressionQuality: 1.0) else { return }
            
            ///
            /// If all went well, create the NFTObject and it's related objects
            ///
            
            var nftImage: NFTImage {
                if isUpdating {
                    return nftObject.image!
                } else {
                    let newNFTImage = NFTImage(context: context)
                    newNFTImage.blob = imageBlob
                    
                    return newNFTImage
                }
            }
            
            nftObject.address = item.address
            nftObject.tokenId = item.tokenId
            nftObject.standard = item.standard
            nftObject.title = item.title
            nftObject.text = item.text

            nftObject.image = nftImage
            nftObject.simulationUrl = item.simulationUrl
            nftObject.animationUrl = item.animationUrl
            
            nftObject.twitterUrl = item.twitterUrl
            nftObject.discordUrl = item.discordUrl
            nftObject.openseaUrl = item.openseaUrl
            nftObject.externalUrl = item.externalUrl
            nftObject.metadataUrl = item.metadataUrl

            nftObject.wallet = wallet
            
            nftObject.timestamp = Date()
            
            //
            // Update the attributes
            //
            
//            let attributesToDelete: [NFTAttribute] = nftObject.attributes.
//            attributesToDelete.forEach { context.delete($0) }
            
//            nftObject.attributes!.forEach { context.delete($0) }
            
            item.attributes.forEach { data in

                let newNFTAttribute = NFTAttribute(context: context)
                newNFTAttribute.key = data.key
                newNFTAttribute.value = data.value
                
                newNFTAttribute.object = nftObject
            }
            
        }
        
        
        
        
        ///
        /// Delete cached items which are not in the list
        ///
        
        for entry in cached {
            
            let item = list.first { $0.address == entry.address && $0.tokenId == entry.tokenId }
            
            if item == nil {
                context.delete(entry)
            }
        }
        
        
        ///
        /// Finally commit all changes
        ///
        
        try commit()
        
    }
    
    // MARK: - Private
    
    private func commit() throws {
        let context = PersistenceController.shared.container.viewContext
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

