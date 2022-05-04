//
//  Collection.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/25/22.
//

import Foundation
import UIKit


struct Collection: Identifiable, Hashable {
    let id: String
    
    let address: String
    
    let title: String?
    let text: String?

    let banner: UIImage?
    let thumbnail: UIImage?
    
    let twitterUrl: URL?
    let instagramUrl: URL?
    let wikiUrl: URL?
    let discordUrl: URL?
    let chatUrl: URL?
    let openseaUrl: URL?
    
    let externalUrl: URL?
}
