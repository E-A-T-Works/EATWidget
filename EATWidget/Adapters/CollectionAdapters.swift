//
//  CollectionAdapters.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import Foundation
import UIKit


final class CollectionAdapters {
    
    static let shared: CollectionAdapters = CollectionAdapters()
    
    private init() {}
    
    func parse(item: APICollection) async -> Collection? {
        let address = item.address
        
        switch address {
        default:
            return await normalizeGeneric(for: item)
        }
    }
}


// MARK: - Generic

extension CollectionAdapters {
    private func normalizeGeneric(for item: APICollection) async -> Collection? {
            
        let thumbnailData = item.thumbnailUrl != nil ? try? Data(contentsOf: item.thumbnailUrl!) : nil
        let thumbnail = thumbnailData != nil ? UIImage(data: thumbnailData!) : nil
        
        let bannerData = item.bannerUrl != nil ? try? Data(contentsOf: item.bannerUrl!) : nil
        let banner = bannerData != nil ? UIImage(data: bannerData!) : nil
     
        var links: [ExternalLink] = [ExternalLink]()
        
        if item.chatUrl != nil {
            links.append(ExternalLink(target: .Chat, url: item.chatUrl!))
        }
        
        if item.discordUrl != nil {
            links.append(ExternalLink(target: .Discord, url: item.discordUrl!))
        }
        
        if item.wikiUrl != nil {
            links.append(ExternalLink(target: .Wiki, url: item.wikiUrl!))
        }
        
        if item.externalUrl != nil {
            links.append(ExternalLink(target: .Other, url: item.externalUrl!))
        }
        
        if item.twitterUsername != nil {
            links.append(ExternalLink(target: .Twitter, url: URL(string: "https://twitter.com/\(item.twitterUsername!)")!))
        }
        
        if item.instagramUsername != nil {
            links.append(ExternalLink(target: .Instagram, url: URL(string: "https://www.instagram.com/\(item.twitterUsername!)")!))
        }
        
        
        return Collection(
            id: item.id,
            address: item.address,
            
            title: item.title,
            text: item.text,
            
            links: links,
            
            banner: banner,
            thumbnail: thumbnail
            
        )
    }
}


//        guard Auth.auth().currentUser != nil else {
//            return nil
//        }
//
//        let db = Firestore.firestore()
//        let storage = Storage.storage()
//
//        let ref = db
//            .collection("contracts")
//            .document(address)
//
//        guard let snapshot = try? await ref.getDocument() else { return nil }
//        guard snapshot.exists else { return nil }
//
//        let data = snapshot.data()
//
//        //
//        // download banner
//        //
//
//        let bannerURL = try? await storage.reference().child("contracts/\(address)/banner.png").downloadURL()
//        let bannerData = bannerURL != nil ? try? Data(contentsOf: bannerURL!) : nil
//        let bannerImage = bannerData != nil ? UIImage(data: bannerData!) : nil
//
//        //
//        // download thumbnail
//        //
//
//        let thumbnailURL = try? await storage.reference().child("contracts/\(address)/thumbnail.png").downloadURL()
//        let thumbnailData = thumbnailURL != nil ? try? Data(contentsOf: thumbnailURL!) : nil
//        let thumbnailImage = thumbnailData != nil ? UIImage(data: thumbnailData!) : nil
//
//        //
//        // parse links
//        //
//
//        // TODO: resolve links
//
//        //
//        // return Collection
//        //
//
//        let collection = Collection(
//            id: snapshot.documentID,
//            address: snapshot.documentID,
//            title: (data?["title"] ?? "Untitled") as! String,
//            text: data?["text"] as? String,
//            links: [ExternalLink](),
//            banner: bannerImage,
//            thumbnail: thumbnailImage
//        )
//
//        return collection
