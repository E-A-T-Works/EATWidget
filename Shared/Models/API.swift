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

struct API_NFT {
    let id: String
    
    let address: String
    let tokenId: String
    
    let title: String?
    let text: String?
    
    let imageUrl: URL?
    let animationUrl: URL?
    
    let metadataUrl: URL?
    
    let permalink: URL?
    
    let attributes: [API_NFT_Attribute]
}
