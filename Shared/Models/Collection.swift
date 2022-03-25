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
    
    let title: String
    let text: String?
    
    let assetCount: Int
    
    let banner: UIImage?
    let thumbnail: UIImage?
}
