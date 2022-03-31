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
        
            var banner: CachedImage?
            if data.banner != nil {
                let blob = data.banner?.jpegData(compressionQuality: 1.0)
                if blob != nil {
                    banner = CachedImage(context: context)
                    banner?.blob = blob
                }
            }
            
            var thumbnail: CachedImage?
            if data.thumbnail != nil {
                let blob = data.thumbnail?.jpegData(compressionQuality: 1.0)
                if blob != nil {
                    thumbnail = CachedImage(context: context)
                    thumbnail?.blob = blob
                }
            }
            
            
            let newObject = CachedCollection(context: context)
            newObject.address = data.address
            
            newObject.title = data.title
            newObject.text = data.text
            
            newObject.banner = banner
            newObject.thumbnail = thumbnail
          
            newObject.chatUrl = data.links.first(where: { $0.target == .Chat })?.url
            newObject.discordUrl = data.links.first(where: { $0.target == .Discord })?.url
            newObject.wikiUrl = data.links.first(where: { $0.target == .Wiki })?.url
            newObject.externalUrl = data.links.first(where: { $0.target == .Other })?.url
            newObject.twitterUrl = data.links.first(where: { $0.target == .Twitter })?.url
            newObject.instagramUrl = data.links.first(where: { $0.target == .Instagram })?.url
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

            var banner: CachedImage?
            if update!.banner != nil {
                let blob = update!.banner?.jpegData(compressionQuality: 1.0)
                if blob != nil {
                    banner = CachedImage(context: context)
                    banner?.blob = blob
                }
            }
            
            var thumbnail: CachedImage?
            if update!.thumbnail != nil {
                let blob = update!.banner?.jpegData(compressionQuality: 1.0)
                if blob != nil {
                    thumbnail = CachedImage(context: context)
                    thumbnail?.blob = blob
                }
            }
            
            cached.title = update!.title
            cached.text = update!.text
            
            cached.banner = banner
            cached.thumbnail = thumbnail
          
            cached.chatUrl = update!.links.first(where: { $0.target == .Chat })?.url
            cached.discordUrl = update!.links.first(where: { $0.target == .Discord })?.url
            cached.wikiUrl = update!.links.first(where: { $0.target == .Wiki })?.url
            cached.externalUrl = update!.links.first(where: { $0.target == .Other })?.url
            cached.twitterUrl = update!.links.first(where: { $0.target == .Twitter })?.url
            cached.instagramUrl = update!.links.first(where: { $0.target == .Instagram })?.url
            
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
