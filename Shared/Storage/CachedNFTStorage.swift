//
//  CachedNFTStorage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation
import UIKit
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

    func syncWithNFTs(wallet: Wallet, list: [NFT]) async throws {
        
        print("syncWithNFTs")
        
        let context = PersistenceController.shared.container.viewContext
        
        // TODO: This should be handled with the query rather than a filter {}
        let cached = fetch().filter { $0.wallet!.address == wallet.address }
        
        await list.asyncForEach { [list] indexPath in
            guard let item = (list.first { $0.address == indexPath.address && $0.tokenId == indexPath.tokenId }) else {
                return
            }
            
//            let entry = cached.first { $0.address == item.address && $0.tokenId == item.tokenId }
//
            print("➡️ Caching \(item.tokenId)")
            
            // CREATE IMAGE
            let newImage = NFTImage(context: context)
            
            guard let data = try? Data(contentsOf: item.imageUrl!) else { return }
            
            let image = UIImage(data: data)
            let blob = image?.jpegData(compressionQuality: 1.0)
            
            newImage.blob = blob
            
            
            // CREATE ITEM
            let newItem = CachedNFT(context: context)

            newItem.address = item.address
            newItem.tokenId = item.tokenId
            newItem.standard = item.standard
            newItem.title = item.title
            newItem.text = item.text
            newItem.imageUrl = item.imageUrl
            newItem.thumbnailUrl = item.thumbnailUrl
            newItem.animationUrl = item.animationUrl

            newItem.image = newImage
            
            newItem.wallet = wallet

            newItem.timestamp = Date()
            
            
            print("GOT THE DATA \(data)")
            // load image
//            do {
//
////                guard let data = try await Data(contentsOf: item.imageUrl!) else { return }
//                if let data = try? Data(contentsOf: item.imageUrl!) {
//                    if let image = UIImage(data: data) {
//
//
//
//                    }
//                }
//
//            } catch {
//                print(" Failed to download image")
//                return
//            }
            
            
            // load the image
//            if let data = try? Data(contentsOf: item.imageUrl!) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
            
        }
        
        
        
//        for item in list {
//
//            print("➡️ Caching \(item.tokenId)")
//
//            // add the ones that are not already cached
//            let entry = cached.first { $0.address == item.address && $0.tokenId == item.tokenId }
//
//            if entry != nil {
//                print(" 👍 Update")
//
//
//
//                // update it
//
//                entry?.title = item.title
//                entry?.text = item.text
//                entry?.imageUrl = item.imageUrl
//                entry?.thumbnailUrl = item.thumbnailUrl
//
//                entry?.wallet = wallet
//
//            } else {
//                print(" 🤌 Create")
//                // add it
//
//                let newItem = CachedNFT(context: context)
//
//                newItem.address = item.address
//                newItem.tokenId = item.tokenId
//                newItem.standard = item.standard
//                newItem.title = item.title
//                newItem.text = item.text
//                newItem.imageUrl = item.imageUrl
//                newItem.thumbnailUrl = item.thumbnailUrl
//                newItem.animationUrl = item.animationUrl
//
//                newItem.wallet = wallet
//
//                newItem.timestamp = Date()
//
//            }
//        }
//
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

