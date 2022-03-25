//
//  FirebaseProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/24/22.
//

import Foundation
import Firebase
import UIKit


final class FirebaseProvider {
    static let shared: FirebaseProvider = FirebaseProvider()
    
    private let db = Firestore.firestore()
    
    init() {}
    
    func logWallet(address: String) async {
        
        do {
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            
            try await db
                .collection("wallets")
                .document(address)
                .setData([
                    "timestamp": Date()
                ])

        } catch {
            print("⚠️ Failed to log to firestore \(error)")
        }
        
    }
    
    func logNFT(address: String, tokenId: String, success: Bool) async {
        
        do {
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            
            let ref = db
                .collection("contracts")
                .document(address)
                .collection("assets")
                .document(tokenId)
            
            let snapshot = try await ref.getDocument()
            
            if snapshot.exists {
                try await ref
                    .updateData([
                        "success": success,
                        "modified": Date()
                    ])
            } else {
                try await ref
                    .setData([
                        "success": success,
                        "modified": Date(),
                        "timestamp": Date()
                    ])
            }
            
        } catch {
            print("⚠️ Failed to log to firestore \(error)")
        }
        
    }
    
    func loadCollection(for address: String) async -> Collection? {
        do {
            guard Auth.auth().currentUser != nil else {
                return nil
            }
            
            let db = Firestore.firestore()
            
            let ref = db
                .collection("contracts")
                .document(address)
            
            let snapshot = try await ref.getDocument()
            
            guard snapshot.exists else { return nil }
            
            let data = snapshot.data()
            
            
            // TODO: Think more about how we get images
                        
            let bannerImageData = try Data(contentsOf: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2\(address)%2Fbanner.png?alt=media&token=e6f96e72-067e-4c02-bcbe-c5f0d0288e20")!)
            let thumbnailImageData = try Data(contentsOf: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2\(address)%2Fthumbnail.png?alt=media&token=e6f96e72-067e-4c02-bcbe-c5f0d0288e20")!)
            
            
            let collection = Collection(
                id: snapshot.documentID,
                title: (data?["title"] ?? "Untitled") as! String,
                text: data?["text"] as? String,
                assetCount: (data?["assetCount"] ?? 0) as! Int,
                banner: UIImage(data: bannerImageData),
                thumbnail: UIImage(data: thumbnailImageData)
            )
            
            return collection
            
        } catch {
            print("⚠️ \(error)")
            return nil
        }
    }
}
