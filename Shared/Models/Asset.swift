//
//  Asset.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//
//  References:
//      https://matteomanferdini.com/codable/
//

import SwiftUI

struct Asset: Identifiable, Hashable {
    let id: String
    
    let tokenId: String
    
    let title: String?
    let text: String?
    
    let backgroundColor: UIColor?
    
    let permalink: URL?
    let externalLink: URL?
    
    let imageThumbnailUrl: URL?
    
    let imageUrl: URL?
    let imageOriginalUrl: URL?
    
    let animationUrl: URL?
    let animationOriginalUrl: URL?
    
    let tokenMetadata: URL?
    
    let contract: Contract
    let creator: Creator?
    let traits: [Trait]?
    let collection: Collection?

    let deepLink: URL
}

extension Asset: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tokenId = "token_id"
        case title = "name"
        case text = "description"
        case backgroundColor = "background_color"
        case permalink = "permalink"
        case externalLink = "external_link"
        case imageThumbnailUrl = "image_thumbnail_url"
        case imageUrl = "image_url"
        case imageOriginalUrl = "image_original_url"
        case animationUrl = "animation_url"
        case animationOriginalUrl = "animation_original_url"
        case tokenMetadata = "token_metadata"
        case contract = "asset_contract"
        case traits = "traits"
        case creator = "creator"
        case collection = "collection"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try String(container.decode(Int.self, forKey: .id))
        tokenId = try container.decode(String.self, forKey: .tokenId)
        
        title = (try? container.decode(String.self, forKey: .title)) ?? nil
        text = (try? container.decode(String.self, forKey: .text)) ?? nil
        
        let backgroundColorHex = (try? container.decode(String.self, forKey: .backgroundColor)) ?? nil
        backgroundColor = backgroundColorHex != nil ? UIColor(hexString: backgroundColorHex) : UIColor.clear
        
        permalink = (try? URL(string: container.decode(String.self, forKey: .permalink))) ?? nil
        externalLink = (try? URL(string: container.decode(String.self, forKey: .externalLink))) ?? nil
        
        imageThumbnailUrl = (try? URL(string: container.decode(String.self, forKey: .imageThumbnailUrl))) ?? nil
        
        imageUrl = (try? URL(string: container.decode(String.self, forKey: .imageUrl))) ?? nil
        imageOriginalUrl = (try? URL(string: container.decode(String.self, forKey: .imageOriginalUrl))) ?? nil
        
        animationUrl = (try? URL(string: container.decode(String.self, forKey: .animationUrl))) ?? nil
        animationOriginalUrl = (try? URL(string: container.decode(String.self, forKey: .animationOriginalUrl))) ?? nil
        
        tokenMetadata = (try? URL(string: container.decode(String.self, forKey: .tokenMetadata))) ?? nil
        
        contract = try container.decode(Contract.self, forKey: .contract)
        
        traits = (try? container.decode([Trait].self, forKey: .traits)) ?? nil
        
        creator = (try? container.decode(Creator.self, forKey: .creator)) ?? nil
        
        collection = (try? container.decode(Collection.self, forKey: .collection)) ?? nil
        
        deepLink = URL(string: "canvas://\(contract.address)/\(tokenId)")!
    }
}
