//
//  NFT.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation
import UIKit


struct Attribute: Hashable {
    let key: String
    let value: String
}


struct NFT: Identifiable, Hashable {
    let id: String
    
    let address: String
    let tokenId: String
    let standard: String
    
    let title: String?
    let text: String?
    
    let image: UIImage
    let simulationUrl: URL?
    let animationUrl: URL?
    
    
    let twitterUrl: URL?
    let discordUrl: URL?
    let openseaUrl: URL?
    let externalUrl: URL?
    let metadataUrl: URL?
    
    let attributes: [Attribute]
}

