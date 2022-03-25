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
    private let storage = Storage.storage()
    
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
            
            let bannerURL = try await storage.reference().child("contracts/\(address)/banner.png").downloadURL()
            let thumbnailURL = try await storage.reference().child("contracts/\(address)/thumbnail.png").downloadURL()

            let collection = Collection(
                id: snapshot.documentID,
                title: (data?["title"] ?? "Untitled") as! String,
                text: data?["text"] as? String,
                assetCount: (data?["assetCount"] ?? 0) as! Int,
                banner: bannerURL,
                thumbnail: thumbnailURL
            )
            
            return collection
            
        } catch {
            print("⚠️ \(error)")
            return nil
        }
    }
}
