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
    
    var list = CurrentValueSubject<[NFTObject], Never>([])
    
    private let fetchRequest: NSFetchRequest<NFTObject>
    private let fetchedResultsController: NSFetchedResultsController<NFTObject>
    
    static let shared: NFTObjectStorage = NFTObjectStorage()
    
    // MARK: - Init
    
    private override init() {
        fetchRequest = NFTObject.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \NFTObject.timestamp, ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        
        do {
            try fetchedResultsController.performFetch()
            list.value = fetchedResultsController.fetchedObjects ?? []
        } catch {
            let nsError = error as NSError
            fatalError("⚠️ Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Public
    
    func fetch() -> [NFTObject] {
        var list: [NFTObject] {
            do {
                try fetchedResultsController.performFetch()
                return fetchedResultsController.fetchedObjects ?? []
            } catch {
                print("⚠️ \(error)")
                return []
            }
        }
        
        return list
    }
    
    func create(
        address: String,
        tokenId: String,
        standard: String,
        title: String,
        text: String?,
        animationUrl: URL?,
        image: NFTImage,
        attributes: [NFTAttribute]?,
        wallet: NFTWallet
    ) throws -> NFTObject {
        let context = PersistenceController.shared.container.viewContext
        
        let newObject = NFTObject(context: context)
        
        newObject.address = address
        newObject.tokenId = tokenId
        newObject.standard = standard
        newObject.title = title
        newObject.text = text
        newObject.animationUrl = animationUrl
        
        newObject.image = image
        
        newObject.attributes = .init(array: attributes ?? [])
        
        newObject.wallet = wallet
        
        newObject.timestamp = Date()
        
        try commit()
        
        return newObject
    }
    
    func delete(object: NFTObject) throws {
        let context = PersistenceController.shared.container.viewContext
        context.delete(object)
        
        try commit()
    }
    
    func sync(list: [NFT], wallet: NFTWallet) async throws {
        let context = PersistenceController.shared.container.viewContext
                
        ///
        /// Get the relevent cached NFTObjects
        /// TODO: Think about how to make use of the filters here rather than manual filter
        ///
        
        let cached = fetch().filter { $0.wallet!.address == wallet.address }
        
        
        ///
        /// Create entries for the items not already stored
        ///
        
        await list.asyncForEach { item in
            
            ///
            /// Determine if this NFT already has an entry in the store. If it does, resume, the data should not
            /// change since it's immutable.
            ///

            let entry = cached.first { $0.address == item.address && $0.tokenId == item.tokenId }
            
            if entry != nil { return }
            
            
            ///
            /// Attempt to download the image. If unable to download it then continue
            ///
        
//            guard let imageData = try? Data(contentsOf: item.imageUrl!) else { return }
//
            // enforce 10mb size limit
//            if imageData.count > (10 * 1_000_000) { return }
            
            guard let imageBlob = item.image.jpegData(compressionQuality: 1.0) else { return }
            
            ///
            /// If all went well, create the NFTObject and it's related objects
            ///
            
            let newNFTImage = NFTImage(context: context)
            newNFTImage.blob = imageBlob
            
            let newNFTAttributes = (item.traits ?? []).map { attribute -> NFTAttribute in
                let newNFTAttribute = NFTAttribute(context: context)
                newNFTAttribute.key = attribute.key
                newNFTAttribute.value = attribute.value
                
                return newNFTAttribute
            }
            
            
            let newNFTObject = NFTObject(context: context)
            
            newNFTObject.address = item.address
            newNFTObject.tokenId = item.tokenId
            newNFTObject.standard = item.standard
            newNFTObject.title = item.title
            newNFTObject.text = item.text
            newNFTObject.animationUrl = item.animationUrl
            
            newNFTObject.image = newNFTImage
            
            newNFTObject.attributes = .init(array: newNFTAttributes)
            
            newNFTObject.wallet = wallet
            
            newNFTObject.timestamp = Date()
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

        self.list.value = list
    }
}

