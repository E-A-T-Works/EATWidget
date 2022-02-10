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
    let text: String?
    
    let assetContractType: String?
    
    let createdDate: Date?
    let nftVersion: String?
    let schemaName: String?
    let symbol: String?
    
    let externalLink: URL?
    let imageUrl: URL?
}

extension Contract: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case address = "address"
        case title = "name"
        case text = "description"
        case assetContractType = "asset_contract_type"
        case createdDate = "created_date"
        case nftVersion = "nft_version"
        case schemaName = "schema_name"
        case symbol = "symbol"
        case externalLink = "external_link"
        case imageUrl = "image_url"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .address)
        address = try container.decode(String.self, forKey: .address)
        
        title = (try? container.decode(String.self, forKey: .title)) ?? nil
        text = (try? container.decode(String.self, forKey: .text)) ?? nil
        
        assetContractType = (try? container.decode(String.self, forKey: .assetContractType)) ?? nil
        
        createdDate = (try? container.decode(Date.self, forKey: .createdDate)) ?? nil
        
        nftVersion = (try? container.decode(String.self, forKey: .nftVersion)) ?? nil
        schemaName = (try? container.decode(String.self, forKey: .schemaName)) ?? nil
        symbol = (try? container.decode(String.self, forKey: .symbol)) ?? nil
        
        externalLink = (try? URL(string: container.decode(String.self, forKey: .externalLink))) ?? nil
        imageUrl = (try? URL(string: container.decode(String.self, forKey: .imageUrl))) ?? nil
    }
}
