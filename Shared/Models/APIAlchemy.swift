//
//  APIAlchemy.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//
//  References:
//      https://docs.alchemy.com/alchemy/enhanced-apis/nft-api/getnftmetadata
//

import Foundation

// MARK: URI


struct APIAlchemyStringUri {
    let raw: String?
    let gateway: String?
}

extension APIAlchemyStringUri: Decodable {
    enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case gateway = "gateway"
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rawString = (try? container.decode(String.self, forKey: .raw)) ?? ""
        
        raw = rawString.isEmpty ? nil : rawString
        
        let gatewayString = (try? container.decode(String.self, forKey: .gateway)) ?? ""
    
        gateway = gatewayString.isEmpty ? nil : gatewayString
    }
}

struct APIAlchemyUri {
    let raw: URL?
    let gateway: URL?
}

extension APIAlchemyUri: Decodable {
    enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case gateway = "gateway"
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rawString = (try? container.decode(String.self, forKey: .raw)) ?? ""
        
        raw = rawString.isEmpty || !rawString.isValidURL ? nil : URL(string: rawString)
        
        let gatewayString = (try? container.decode(String.self, forKey: .gateway)) ?? ""
    
        gateway = gatewayString.isEmpty || !gatewayString.isValidURL ? nil : URL(string: gatewayString)
    }
}


// MARK: Contract

struct APIAlchemyContract {
    let address: String
}

extension APIAlchemyContract: Decodable {
    enum CodingKeys: String, CodingKey {
        case address = "address"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
    }
}

// MARK: Token Metadata

struct APIAlchemyTokenMetadata {
    let tokenType: String
}

extension APIAlchemyTokenMetadata: Decodable {
    enum CodingKeys: String, CodingKey {
        case tokenType = "tokenType"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tokenType = try container.decode(String.self, forKey: .tokenType)
    }
}

// MARK: Token Id

struct APIAlchemyTokenId {
    let tokenId: String
    let tokenMetadata: APIAlchemyTokenMetadata
}

extension APIAlchemyTokenId: Decodable {
    enum CodingKeys: String, CodingKey {
        case tokenId = "tokenId"
        case tokenMetadata = "tokenMetadata"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tokenId = try container.decode(String.self, forKey: .tokenId)
        tokenMetadata = try container.decode(APIAlchemyTokenMetadata.self, forKey: .tokenMetadata)
    }
}

// MARK: Attribute

struct APIAlchemyAttribute {
    let traitType: String?
    let value: String?
}

extension APIAlchemyAttribute: Decodable {
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

// MARK: Token Data

struct APIAlchemyMetadata {
    let title: String?
    let text: String?
    let image: String?
    let animationUrl: URL?
    let externalUrl: URL?
    let backgroundColor: String?
    let attributes: [APIAlchemyAttribute]?
}

extension APIAlchemyMetadata: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case text = "description"
        case image = "image"
        case thumbnailUrl = "thumbnail_url"
        case animationUrl = "animation_url"
        case externalUrl = "external_url"
        case backgroundColor = "background_color"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = (try? container.decode(String.self, forKey: .title)) ?? nil
        text = (try? container.decode(String.self, forKey: .text)) ?? nil
        
        image = (try? container.decode(String.self, forKey: .image)) ?? nil
        
        animationUrl = (try? URL(string: container.decode(String.self, forKey: .animationUrl))) ?? nil
        
        externalUrl = (try? URL(string: container.decode(String.self, forKey: .externalUrl))) ?? nil
        
        backgroundColor = (try? container.decode(String.self, forKey: .backgroundColor)) ?? nil
        
        attributes = (try? container.decode([APIAlchemyAttribute].self, forKey: .attributes)) ?? nil
    }
}


// MARK: Token Data

struct APIAlchemyNFT {
    let contract: APIAlchemyContract
    let id: APIAlchemyTokenId
    
    let title: String
    let text: String?
    
    let tokenUri: APIAlchemyUri
    
    let media: [APIAlchemyUri]
    let metadata: APIAlchemyMetadata?
}

extension APIAlchemyNFT: Decodable {
    enum CodingKeys: String, CodingKey {
        case contract = "contract"
        case id = "id"
        case title = "title"
        case text = "description"
        case tokenUri = "tokenUri"
        case media = "media"
        case metadata = "metadata"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contract = try container.decode(APIAlchemyContract.self, forKey: .contract)
        id = try container.decode(APIAlchemyTokenId.self, forKey: .id)
        
        let rawTitle = try container.decode(String.self, forKey: .title)
        title = rawTitle.isEmpty ? id.tokenId : rawTitle
        
        text = (try? container.decode(String.self, forKey: .text)) ?? nil
        
        tokenUri = try container.decode(APIAlchemyUri.self, forKey: .tokenUri)
        
        media = try container.decode([APIAlchemyUri].self, forKey: .media)
        
        metadata = (try? container.decode(APIAlchemyMetadata.self, forKey: .metadata)) ?? nil
    }
}


extension APIAlchemyNFT {
    var isValid: Bool {
        guard let media = self.media.first else {
            return false
        }
        
        if media.raw == nil || media.gateway == nil {
            return false
        }
        
        return true
    }
}

// MARK: API Response

struct APIAlchemyGetNFTsResponse {
    let ownedNfts: [APIAlchemyNFT]
    let totalCount: Int
}

extension APIAlchemyGetNFTsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case ownedNfts = "ownedNfts"
        case totalCount = "totalCount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

//        ownedNfts = (try? container.decode([APIAlchemyNFT].self, forKey: .ownedNfts)) ?? []
        ownedNfts = (try? container.decode([APIAlchemyNFT].self, forKey: .ownedNfts)) ?? []
        totalCount = (try? container.decode(Int.self, forKey: .totalCount)) ?? 0
    }
}
