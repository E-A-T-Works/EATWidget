//
//  APIOpenSea.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/30/22.
//

import Foundation

struct APIOpenSeaContract {
    let address: String
}

extension APIOpenSeaContract: Decodable {
    enum CodingKeys: String, CodingKey {
        case address = "address"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        address = try container.decode(String.self, forKey: .address)
    }
}


struct APIOpenSeaAttribute {
    let traitType: String?
    let value: String?
}

extension APIOpenSeaAttribute: Decodable {
    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        traitType = (try? container.decode(String.self, forKey: .traitType)) ?? nil
        
        do {
            value = try String(container.decode(Int.self, forKey: .value))
        } catch DecodingError.typeMismatch {
            value = try container.decode(String.self, forKey: .value)
        } catch {
            value = nil
        }
    }
}


struct APIOpenSeaNFT {
    let id: Int
    
    let contract: APIOpenSeaContract
    let tokenId: String
    
    let title: String?
    let text: String?
    
    let imageUrl: URL?
    let animationUrl: URL?
    
    let permalink: URL?
    let metadataUrl: URL?
    let attributes: [APIOpenSeaAttribute]
}

extension APIOpenSeaNFT: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case contract = "asset_contract"
        case tokenId = "token_id"
        case title = "name"
        case text = "description"
        case imageUrl = "image_url"
        case animationUrl = "animation_url"
        case permalink = "permalink"
        case metadataUrl = "token_metadata"
        case attributes = "traits"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        contract = try container.decode(APIOpenSeaContract.self, forKey: .contract)
        tokenId = try container.decode(String.self, forKey: .tokenId)
        title = (try? container.decode(String.self, forKey: .title)) ?? nil
        text = (try? container.decode(String.self, forKey: .text)) ?? nil
        
        imageUrl = (try? URL(string: container.decode(String.self, forKey: .imageUrl))) ?? nil
        animationUrl =  (try? URL(string: container.decode(String.self, forKey: .animationUrl))) ?? nil
        
        permalink = (try? URL(string: container.decode(String.self, forKey: .permalink))) ?? nil
        
        metadataUrl =  (try? URL(string: container.decode(String.self, forKey: .metadataUrl))) ?? nil
        
        attributes = (try? container.decode([APIOpenSeaAttribute].self, forKey: .attributes)) ?? [APIOpenSeaAttribute]()
    }
}


struct APIOpenSeaGetNFTsResponse {
    let assets: [APIOpenSeaNFT]
    let previous: String?
    let next: String?
}

extension APIOpenSeaGetNFTsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case assets = "assets"
        case previous = "previous"
        case next = "next"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        assets = (try? container.decode([APIOpenSeaNFT].self, forKey: .assets)) ?? []
        previous = (try? container.decode(String.self, forKey: .previous)) ?? nil
        next = (try? container.decode(String.self, forKey: .next)) ?? nil
    }
}

