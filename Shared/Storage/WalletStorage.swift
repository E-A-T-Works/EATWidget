//
//  WalletStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import Combine
import CoreData

class WalletStorage: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var wallets = CurrentValueSubject<[Wallet], Never>([])
    
    private let walletFetchRequest: NSFetchRequest<Wallet>
    private let walletFetchController: NSFetchedResultsController<Wallet>
    
    static let shared: WalletStorage = WalletStorage()
    
    // MARK: - Initialization
    
    private override init() {
        walletFetchRequest = Wallet.fetchRequest()
        walletFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Wallet.timestamp, ascending: true)]
        
        walletFetchController = NSFetchedResultsController(
            fetchRequest: walletFetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        walletFetchController.delegate = self
        
        do {
            try walletFetchController.performFetch()
            wallets.value = walletFetchController.fetchedObjects ?? []
        } catch {
            let nsError = error as NSError
            fatalError("⚠️ Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Public Methods
    
    func fetch() -> [Wallet] {
        var wallets: [Wallet] {
            do {
                try walletFetchController.performFetch()
                return walletFetchController.fetchedObjects ?? []
            } catch {
                print("⚠️ \(error.localizedDescription)")
                return []
            }
        }
        
        return wallets
    }
    
    func add(address: String, title: String?) throws {
        let context = PersistenceController.shared.container.viewContext
        
        let newWallet = Wallet(context: context)
        newWallet.id = address
        newWallet.address = address
        newWallet.title = title
        newWallet.timestamp = Date()
        
        try commit()
    }
    
    func delete(object: NSManagedObject) throws {
        let context = PersistenceController.shared.container.viewContext
        context.delete(object)
        
        try commit()
    }
    
    // MARK: - Private Methods
    
    private func commit() throws {
        let context = PersistenceController.shared.container.viewContext
        
        try context.save()
    }
}

extension WalletStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let wallets = controller.fetchedObjects as? [Wallet] else { return }
        self.wallets.value = wallets
    }
}

