//
//  CachedWalletStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/22/22.
//

import Foundation
import Combine
import CoreData


final class CachedWalletStorage: NSObject, ObservableObject {
    
    static let shared: CachedWalletStorage = CachedWalletStorage()

    
    @Published var list: [CachedWallet] = [CachedWallet]()
    
    private let fetchRequest: NSFetchRequest<CachedWallet>
    private let fetchedResultsController: NSFetchedResultsController<CachedWallet>
    
    
    private let persistenceController = PersistenceController.shared
    
    
    
    private override init() {
        fetchRequest = CachedWallet.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \CachedWallet.address, ascending: false)
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
    

    
    func fetch() -> [CachedWallet] {
        var list: [CachedWallet] {
            do {
                try fetchedResultsController.performFetch()
                return fetchedResultsController.fetchedObjects ?? [CachedWallet]()
            } catch {
                print("⚠️ \(error)")
                return [CachedWallet]()
            }
        }
        
        return list
    }
    
    func set(address: String, title: String?) throws -> CachedWallet {
        let context = persistenceController.container.viewContext
        
        let cached = fetch().first { $0.address == address }
        
        guard cached == nil else {
            return try update(object: cached!, title: title)
        }
        
        let newObject = CachedWallet(context: context)
        newObject.address = address
        newObject.title = title
        newObject.timestamp = Date()
        
        try commit()
        
        return newObject
    }
    
    func update(object: CachedWallet, title: String?) throws -> CachedWallet {
        object.title = title
        
        try commit()
        
        return object
    }
    
    func delete(object: CachedWallet) throws {
        let context = persistenceController.container.viewContext
        
        context.delete(object)
        
        try commit()
    }
    
    
    
    private func commit() throws {
        let context = PersistenceController.shared.container.viewContext
        try context.save()
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate Extension

extension CachedWalletStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [CachedWallet] else { return }

        self.list = list
    }
}
