//
//  Contract.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//
//  References:
//      https://matteomanferdini.com/codable/
//
//

import Foundation

struct Contract: Identifiable, Hashable {
    let id: String
    
    let address: String
    let title: String?
}

extension Contract: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case address = "address"
        case title = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .address)
        address = try container.decode(String.self, forKey: .address)
        
        title = (try? container.decode(String.self, forKey: .title)) ?? nil
    }
}
