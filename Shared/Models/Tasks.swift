//
//  Tasks.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/30/22.
//

import Foundation


enum NFTParseTaskState: String {
    case pending, success, failure
}

struct NFTParseTask: Identifiable {
    let id: String
    
    let address: String
    let tokenId: String
    
    var state: NFTParseTaskState
    
    var collection: APICollection?
    var raw: API_NFT
    var parsed: NFT?
}
