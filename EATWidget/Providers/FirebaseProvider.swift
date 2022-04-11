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
    
    func logWallet(address: String, parsedCount: Int = 0, successCount: Int = 0, failureCount: Int = 0) async {
        
        do {
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            
            try await db
                .collection("wallets")
                .document(address)
                .setData([
                    "parsedCount": parsedCount,
                    "successCount": successCount,
                    "failureCount": failureCount,
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

    func logRefresh() async {
        do {
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let uid = Auth.auth().currentUser!.uid
            let db = Firestore.firestore()
            
            try await db
                .collection("refreshes")
                .document(uid)
                .setData([
                    "timestamp": Date()
                ])

        } catch {
            print("⚠️ Failed to log to firestore \(error)")
        }
    }
}

