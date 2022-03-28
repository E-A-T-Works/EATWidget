//
//  CollectionAdapters.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import Foundation
import Firebase
import UIKit


final class CollectionAdapters {
    
    static let shared: CollectionAdapters = CollectionAdapters()
    
    private init() {}
    
    func parse(address: String) async -> Collection? {
        
        
        
        do {
            guard Auth.auth().currentUser != nil else {
                return nil
            }
            
            let db = Firestore.firestore()
            let storage = Storage.storage()
            
            let ref = db
                .collection("contracts")
                .document(address)
            
            let snapshot = try await ref.getDocument()
            
            guard snapshot.exists else { return nil }
            
            let data = snapshot.data()
            
            //
            // download banner
            //
            
            let bannerURL = try await storage.reference().child("contracts/\(address)/banner.png").downloadURL()
            
            let bannerData = try Data(contentsOf: bannerURL)
            
            guard let bannerImage = UIImage(data: bannerData) else { return nil }
            
            //
            // download thumbnail
            //
            
            let thumbnailURL = try await storage.reference().child("contracts/\(address)/thumbnail.png").downloadURL()
            
            let thumbnailData = try Data(contentsOf: thumbnailURL)
            
            guard let thumbnailImage = UIImage(data: thumbnailData) else { return nil }

            //
            // parse links
            //
            
            // TODO:
            
            //
            // return Collection
            //
            
            let collection = Collection(
                id: snapshot.documentID,
                address: snapshot.documentID,
                title: (data?["title"] ?? "Untitled") as! String,
                text: data?["text"] as? String,
                links: [ExternalLink](),
                banner: bannerImage,
                thumbnail: thumbnailImage
            )
            
            return collection
            
        } catch {
            print("⚠️ \(error)")
            return nil
        }
    }
}
