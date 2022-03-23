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
    
    static let shared: NFTWalletStorage = NFTWalletStorage()

    
    @Published var list: [NFTWallet] = [NFTWallet]()
    
    private let fetchRequest: NSFetchRequest<NFTWallet>
    private let fetchedResultsController: NSFetchedResultsController<NFTWallet>
    
    
    private let persistenceController = PersistenceController.shared
    
    
    
    private override init() {
        fetchRequest = NFTWallet.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \NFTWallet.address, ascending: false)
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
    

    
    func fetch() -> [NFTWallet] {
        var list: [NFTWallet] {
            do {
                try fetchedResultsController.performFetch()
                return fetchedResultsController.fetchedObjects ?? [NFTWallet]()
            } catch {
                print("⚠️ \(error)")
                return [NFTWallet]()
            }
        }
        
        return list
    }
    
//    func sync(list: [Wallet]) -> [NFTWallet] {
//
//        let context = persistenceController.container.viewContext
//
//        let cached = fetch()
//
//        //
//        // Handle creation
//        //
//
//        let toCreate = list.filter { !cached.map { $0.address }.contains($0.address) }
//
//        toCreate.forEach { data in
//            let newObject = NFTWallet(context: context)
//            newObject.address = data.address
//            newObject.title = data.title
//            newObject.timestamp = Date()
//        }
//
//        //
//        // Handle updates
//        //
//
//        let toUpdate = cached.filter { list.map { $0.address }.contains($0.address) }
//
//        toUpdate.forEach { cached in
//            let update = list.first { $0.address == cached.address }
//            guard update != nil else { return }
//
//            cached.title = update!.title
//        }
//
//
//        //
//        // Handle deletion
//        //
//
//        let toDelete = cached.filter { !list.map { $0.address }.contains($0.address) }
//
//        toDelete.forEach { context.delete($0) }
//
//        //
//        // Commit
//        //
//
//        do {
//            try context.save()
//        } catch {
//            print("⚠️ Failed to Write \(error)")
//        }
//
//
//        return fetch()
//
//    }
    
    
    func set(address: String, title: String?) throws -> NFTWallet {
        let context = persistenceController.container.viewContext
        
        let cached = fetch().first { $0.address == address }
        
        guard cached == nil else {
            return try update(object: cached!, title: title)
        }
        
        let newObject = NFTWallet(context: context)
        newObject.address = address
        newObject.title = title
        newObject.timestamp = Date()
        
        try commit()
        
        return newObject
    }
    
    func update(object: NFTWallet, title: String?) throws -> NFTWallet {
        object.title = title
        
        try commit()
        
        return object
    }
    
    func delete(object: NFTWallet) throws {
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

extension NFTWalletStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [NFTWallet] else { return }

        self.list = list
    }
}
