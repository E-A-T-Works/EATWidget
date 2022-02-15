//
//  NFTOptionStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation
import Combine
import CoreData

class NFTOptionStorage: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var options = CurrentValueSubject<[NFTOption], Never>([])
    
    private let optionsFetchRequest: NSFetchRequest<NFTOption>
    private let optionsFetchController: NSFetchedResultsController<NFTOption>
    
    static let shared: NFTOptionStorage = NFTOptionStorage()
    
    // MARK: - Initialization
    
    private override init() {
        optionsFetchRequest = NFTOption.fetchRequest()
        optionsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \NFTOption.timestamp, ascending: true)]
        
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
    
    func fetch() -> [NFTOption] {
        var options: [NFTOption] {
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
    
    func add(wallet: Wallet, identifier: String, display: String, subtitle: String?, imageUrl: URL?) throws {
        let context = PersistenceController.shared.container.viewContext
        
        let newItem = NFTOption(context: context)
        
        newItem.identifier = identifier
        newItem.display = display
        newItem.subtitle = subtitle
        newItem.imageUrl = imageUrl
        
        newItem.wallet = wallet

        try commit()
    }
    
    func delete(object: NSManagedObject) throws {
        let context = PersistenceController.shared.container.viewContext
        context.delete(object)
        
        try commit()
    }
    
    func syncWithNFTs(wallet: Wallet, list: [NFT]) throws {
        let context = PersistenceController.shared.container.viewContext
        
        // TODO: This should be handled with the query rather than a filter {}
        let cached = fetch().filter { $0.wallet!.address == wallet.address }
        
        for item in list {
            // add the ones that are not already cached
            let entry = cached.first { $0.identifier == item.id }
            
            if entry != nil {
                // update it
                entry?.identifier = item.id
                entry?.display = item.title ?? item.tokenId
                entry?.subtitle = item.collection?.title ?? nil
                entry?.imageUrl = nil
                
                entry?.wallet = wallet
                
            } else {
                // add it
                
                let newItem = NFTOption(context: context)
                
                newItem.identifier = item.id
                newItem.display = item.title ?? item.tokenId
                newItem.subtitle = item.collection?.title ?? nil
                newItem.imageUrl = nil
                
                newItem.wallet = wallet
                
            }
        }
   
        // delete the ones that are cached but not in the list
        for entry in cached {
            let item = list.first { $0.id == entry.identifier }
            
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

extension NFTOptionStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let options = controller.fetchedObjects as? [NFTOption] else { return }
        self.options.value = options
    }
}

