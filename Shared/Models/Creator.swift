//
//  Creator.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/10/22.
//

import Foundation

struct Creator: Identifiable, Hashable {
    let id: String
    let address: String
    
    let user: User?
    let profileImageUrl: URL?
}


extension Creator: Decodable {
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case user = "user"
        case profileImageUrl = "profile_img_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .address)
        address = try container.decode(String.self, forKey: .address)
        
        user = (try? container.decode(User.self, forKey: .user)) ?? nil
        profileImageUrl = (try? URL(string: container.decode(String.self, forKey: .profileImageUrl))) ?? nil
    }
}
