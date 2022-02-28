//
//  NFTWalletStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/22/22.
//

import Foundation
import Combine
import CoreData


final class NFTWalletStorage: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var list = CurrentValueSubject<[NFTWallet], Never>([])
    
    private let fetchRequest: NSFetchRequest<NFTWallet>
    private let fetchedResultsController: NSFetchedResultsController<NFTWallet>
    
    static let shared: NFTWalletStorage = NFTWalletStorage()
    
    // MARK: - Init
    
    private override init() {
        fetchRequest = NFTWallet.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \NFTWallet.address, ascending: false)
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
    
    func fetch() -> [NFTWallet] {
        var list: [NFTWallet] {
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
    
    func create(address: String, title: String?) throws -> NFTWallet {
        let context = PersistenceController.shared.container.viewContext
        
        let newObject = NFTWallet(context: context)
        newObject.address = address
        newObject.title = title
        newObject.timestamp = Date()
        
        try commit()
        
        return newObject
    }
    
    func update(title: String?, object: NFTWallet) throws -> NFTWallet {
        object.title = title
        
        try commit()
        
        return object
    }
    
    func delete(object: NFTWallet) throws {
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

extension NFTWalletStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [NFTWallet] else { return }

        self.list.value = list
    }
}
