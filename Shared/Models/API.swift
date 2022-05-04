//
//  API.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation

enum APIError: Error {
    case InvalidUrl
    case BadResponse
    case Unsupported
    case MissingKey
}


struct API_NFT_Attribute {
    let key: String
    let value: String
}

struct API_NFT: Identifiable {
    let id: String
    
    let address: String
    let tokenId: String
    
    let collection: APICollection?
    
    let title: String?
    let text: String?
    
    let imageUrl: URL?
    let animationUrl: URL?
    
    let openseaUrl: URL?
    let externalUrl: URL?
    let metadataUrl: URL?
    
    let attributes: [API_NFT_Attribute]
}


struct APICollection: Identifiable {
    let id: String
    
    let address: String
    
    let title: String?
    let text: String?
    
    let thumbnailUrl: URL?
    let bannerUrl: URL?
    
    let twitterUrl: URL?
    let instagramUrl: URL?
    let wikiUrl: URL?
    let discordUrl: URL?
    let chatUrl: URL?
    let openseaUrl: URL?
    let externalUrl: URL?
}

struct APIContract: Identifiable {
    let id: String
    let address: String
    let collection: APICollection
}
