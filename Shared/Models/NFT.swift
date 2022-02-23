//
//  NFT.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation
import UIKit


struct NFTTrait: Hashable {
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
    
    let animationUrl: URL?
    let externalURL: URL?
    
    let traits: [NFTTrait]?
}

