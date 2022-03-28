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
        
        guard Auth.auth().currentUser != nil else {
            return nil
        }
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        let ref = db
            .collection("contracts")
            .document(address)
        
        guard let snapshot = try? await ref.getDocument() else { return nil }
        guard snapshot.exists else { return nil }
        
        let data = snapshot.data()
        
        //
        // download banner
        //
        
        let bannerURL = try? await storage.reference().child("contracts/\(address)/banner.png").downloadURL()
        let bannerData = bannerURL != nil ? try? Data(contentsOf: bannerURL!) : nil
        let bannerImage = bannerData != nil ? UIImage(data: bannerData!) : nil
        
        //
        // download thumbnail
        //
        
        let thumbnailURL = try? await storage.reference().child("contracts/\(address)/thumbnail.png").downloadURL()
        let thumbnailData = thumbnailURL != nil ? try? Data(contentsOf: thumbnailURL!) : nil
        let thumbnailImage = thumbnailData != nil ? UIImage(data: thumbnailData!) : nil

        //
        // parse links
        //
        
        // TODO: resolve links
        
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
    }
}
