//
//  APIEnsideas.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 4/6/22.
//

import Foundation


struct APIEnsideasGetResponse {
    let address: String
    let name: String
    
}

extension APIEnsideasGetResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        address = try container.decode(String.self, forKey: .address)
        name = try container.decode(String.self, forKey: .name)
    }
}
