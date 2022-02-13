//
//  Trait.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/13/22.
//

import Foundation

struct Trait: Hashable {
    let traitType: String?
    let value: String?
}

extension Trait: Decodable {
    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        traitType = (try? container.decode(String.self, forKey: .traitType)) ?? nil
        value = (try? container.decode(String.self, forKey: .value)) ?? nil
    }
}
