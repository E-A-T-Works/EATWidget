//
//  CachedNFTStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation
import Combine
import CoreData

class CachedNFTStorage: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var options = CurrentValueSubject<[CachedNFT], Never>([])
    
    private let optionsFetchRequest: NSFetchRequest<CachedNFT>
    private let optionsFetchController: NSFetchedResultsController<CachedNFT>
    
    static let shared: CachedNFTStorage = CachedNFTStorage()
    
    // MARK: - Initialization
    
    private override init() {
        optionsFetchRequest = CachedNFT.fetchRequest()
        optionsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CachedNFT.timestamp, ascending: true)]
        
        optionsFetchController = NSFetchedResultsController(
            fetchRequest: optionsFetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        optionsFetchController.delegate = self
        
        do {
            try optionsFetchController.performFetch()
            options.value = optionsFetchController.fetchedObjects ?? []
        } catch {
            let nsError = error as NSError
            fatalError("⚠️ Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Public Methods
    
    func fetch() -> [CachedNFT] {
        var options: [CachedNFT] {
            do {
                try optionsFetchController.performFetch()
                return optionsFetchController.fetchedObjects ?? []
            } catch {
                print("⚠️ \(error)")
                return []
            }
        }
        
        return options
    }

    func syncWithNFTs(wallet: Wallet, list: [NFT]) throws {
        let context = PersistenceController.shared.container.viewContext
        
        // TODO: This should be handled with the query rather than a filter {}
        let cached = fetch().filter { $0.wallet!.address == wallet.address }
        
        for item in list {
            // add the ones that are not already cached
            let entry = cached.first { $0.address == item.address && $0.tokenId == item.tokenId }
            
            if entry != nil {
                // update it
                
                entry?.title = item.title
                entry?.text = item.text
                entry?.imageUrl = item.imageUrl
                entry?.thumbnailUrl = item.thumbnailUrl
                
                entry?.wallet = wallet
                
            } else {
                // add it
                
                let newItem = CachedNFT(context: context)

                newItem.address = item.address
                newItem.tokenId = item.tokenId
                newItem.standard = item.standard
                newItem.title = item.title
                newItem.text = item.text
                newItem.imageUrl = item.imageUrl
                newItem.thumbnailUrl = item.thumbnailUrl
                newItem.animationUrl = item.animationUrl
                
                newItem.wallet = wallet
                
                newItem.timestamp = Date()
                
            }
        }
   
        // delete the ones that are cached but not in the list
        for entry in cached {
            let item = list.first { $0.address == entry.address && $0.tokenId == entry.tokenId }

            if item == nil {
                context.delete(entry)
            }
        }
        
        
        try commit()
        
    }
    
    // MARK: - Private Methods
    
    private func commit() throws {
        let context = PersistenceController.shared.container.viewContext
        
        try context.save()
    }
}

extension CachedNFTStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let options = controller.fetchedObjects as? [CachedNFT] else { return }
        self.options.value = options
    }
}

