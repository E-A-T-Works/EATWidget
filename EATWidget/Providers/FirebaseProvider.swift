//
//  FirebaseProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/24/22.
//

import Foundation
import Firebase


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
            
            try await db
                .collection("contracts")
                .document(address)
                .collection("assets")
                .document(tokenId)
                .setData([
                    "success": success,
                    "timestamp": Date()
                ])
        } catch {
            print("⚠️ Failed to log to firestore \(error)")
        }
        
    }
}
