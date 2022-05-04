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
        case "0x57f1887a8bf19b14fc0df6fd9b2acc9af147ea85":
            return nil // ENS addresses
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
        
        return Collection(
            id: item.id,
            address: item.address,
            
            title: item.title,
            text: item.text,
            
            banner: banner,
            thumbnail: thumbnail,
            
            twitterUrl: item.twitterUrl,
            instagramUrl: item.instagramUrl,
            wikiUrl: item.wikiUrl,
            discordUrl: item.discordUrl,
            chatUrl: item.chatUrl,
            openseaUrl: item.openseaUrl,
            
            externalUrl: item.externalUrl
        )
    }
}
