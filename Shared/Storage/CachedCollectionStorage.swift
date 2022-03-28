//
//  CachedCollectionStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/15/22.
//

import Foundation
import Combine
import CoreData


final class CachedCollectionStorage: NSObject, ObservableObject {
    
    static let shared: CachedCollectionStorage = CachedCollectionStorage()
    
    // MARK: - Properties

    @Published var list: [CachedCollection] = [CachedCollection]()
    
    private let fetchRequest: NSFetchRequest<CachedCollection>
    private let fetchedResultsController: NSFetchedResultsController<CachedCollection>
    
    private let persistenceController = PersistenceController.shared
    
    // MARK: - Init
    
    private override init() {
        fetchRequest = CachedCollection.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \CachedCollection.address, ascending: false)
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
    
    func fetch() -> [CachedCollection] {
        var list: [CachedCollection] {
            do {
                try fetchedResultsController.performFetch()
                return fetchedResultsController.fetchedObjects ?? [CachedCollection]()
            } catch {
                print("⚠️ \(error)")
                return [CachedCollection]()
            }
        }
        
        return list
    }
    
    func sync(list: [Collection]) throws -> [CachedCollection] {
        let context = persistenceController.container.viewContext
        
        let cached = fetch()
        
        //
        // Handle creation
        //
        
        let toCreate = list.filter { item in
            let exists = cached.first { $0.address == item.address } != nil
            return !exists
        }
        
        toCreate.forEach { data in
            
//            guard let imageBlob = data.image.jpegData(compressionQuality: 0.25) else { return }
//
//            let cachedImage = CachedImage(context: context)
//            cachedImage.blob = imageBlob
            
            let newObject = CachedCollection(context: context)
            newObject.address = data.address
        
        }
        
        //
        // Handle updates
        //

        let toUpdate = cached.filter { item in
            let exists = list.first { $0.address == item.address } != nil
            return exists
        }
        
        toUpdate.forEach { cached in
            let update = list.first { $0.address == cached.address }
            guard update != nil else { return }

            cached.title = update!.title
        }
        
        //
        // Commit
        //

        try context.save()
        
        
        return fetch()
    }
    
    func create(address: String, title: String?) throws -> CachedCollection {
        
        let existingObject = fetch().first { $0.address == address }
        if existingObject != nil {
            return try update(title: title, object: existingObject!)
        }
        
        
        let context = PersistenceController.shared.container.viewContext
        
        let newObject = CachedCollection(context: context)
        newObject.address = address
        newObject.title = title
        
        try commit()
        
        return newObject
    }
    
    func update(title: String?, object: CachedCollection) throws -> CachedCollection {
        object.title = title
        
        try commit()
        
        return object
    }
    
    func delete(object: CachedCollection) throws {
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

extension CachedCollectionStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [CachedCollection] else { return }

        self.list = list
    }
}
