//
//  NFTCollectionStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/15/22.
//

import Foundation
import Combine
import CoreData


final class NFTCollectionStorage: NSObject, ObservableObject {
    
    static let shared: NFTCollectionStorage = NFTCollectionStorage()
    
    // MARK: - Properties

    @Published var list: [NFTCollection] = [NFTCollection]()
    
    private let fetchRequest: NSFetchRequest<NFTCollection>
    private let fetchedResultsController: NSFetchedResultsController<NFTCollection>
    
    // MARK: - Init
    
    private override init() {
        fetchRequest = NFTCollection.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \NFTCollection.timestamp, ascending: false)
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
    
    func fetch() -> [NFTCollection] {
        var list: [NFTCollection] {
            do {
                try fetchedResultsController.performFetch()
                return fetchedResultsController.fetchedObjects ?? [NFTCollection]()
            } catch {
                print("⚠️ \(error)")
                return [NFTCollection]()
            }
        }
        
        return list
    }
    
    func create(address: String, title: String?) throws -> NFTCollection {
        
        let existingObject = fetch().first { $0.address == address }
        if existingObject != nil {
            return try update(title: title, object: existingObject!)
        }
        
        
        let context = PersistenceController.shared.container.viewContext
        
        let newObject = NFTCollection(context: context)
        newObject.address = address
        newObject.title = title
        newObject.timestamp = Date()
        
        try commit()
        
        return newObject
    }
    
    func update(title: String?, object: NFTCollection) throws -> NFTCollection {
        object.title = title
        
        try commit()
        
        return object
    }
    
    func delete(object: NFTCollection) throws {
        let context = PersistenceController.shared.container.viewContext
        context.delete(object)
        
        try commit()
    }
    
    // MARK: - Private
    
    private func commit() throws {
        let context = PersistenceController.shared.container.viewContext
        try context.save()
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate Extension

extension NFTCollectionStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [NFTCollection] else { return }

        self.list = list
    }
}
