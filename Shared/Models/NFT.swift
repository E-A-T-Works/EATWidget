//
//  NFT.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation

struct NFT: Hashable {
    let id: String
    let address: String
    
    let title: String?
    let text: String?
    
    let imageUrl: URL?
    let thumbnailUrl: URL?
    let animationUrl: URL?
    let externalURL: URL?
    
    
    let creator: NFTCreator?
    
    let traits: [NFTTrait]?
}

struct NFTCreator: Hashable {
    let address: String
    
    let title: String?
    let text: String?
    
    let imageUrl: URL?
}

struct NFTTrait: Hashable {
    let key: String
    let value: String
}