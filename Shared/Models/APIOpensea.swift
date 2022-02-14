//
//  APIOpensea.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation
import UIKit

enum OpenSeaAssetsResponse {
    case Success(assets: [Asset])
    case Failure
}

enum OpenSeaAssetResponse {
    case Success(asset: Asset)
    case Failure
}

enum OpenSeaImageResponse {
    case Success(image: UIImage)
    case Failure
}

typealias OpenSeaApiAssetResponse = Asset

struct OpenSeaApiAssetsResponse: Decodable {
    let assets: [Asset]
}


// MARK: Contract


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


// MARK: Collection

struct Collection: Hashable {
    
    let title: String?
    let text: String?
    
    let discordUrl: URL?
    let twitterUrl: URL?
    
    let imageUrl: URL?
    
    let paymentTokens: [PaymentToken]?
    
    let createdDate: Date?
    
}

extension Collection: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case text = "description"
        case discordUrl = "discord_url"
        case twitterUrl = "twitter_username"
        case imageUrl = "image_url"
        case paymentTokens = "payment_tokens"
        case createdDate = "created_date"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = (try? container.decode(String.self, forKey: .title)) ?? nil
        text = (try? container.decode(String.self, forKey: .text)) ?? nil
        
        discordUrl = (try? URL(string: container.decode(String.self, forKey: .discordUrl))) ?? nil
        
        let twitterUsername = (try? container.decode(String.self, forKey: .twitterUrl)) ?? nil
        twitterUrl = twitterUsername != nil ? URL(string: "https://twitter.com/\(twitterUsername!)") : nil
        
        imageUrl = (try? URL(string: container.decode(String.self, forKey: .imageUrl))) ?? nil
        
        paymentTokens = (try? container.decode([PaymentToken].self, forKey: .paymentTokens)) ?? nil
        
        createdDate = (try? container.decode(Date.self, forKey: .createdDate)) ?? nil
    }
}



struct CollectionStats: Hashable {
    let oneDayVolume: Double?
    let oneDayChange: Double?
    let oneDaySales: Double?
    let oneDayAveragePrice: Double?
    
    let sevenDayVolume: Double?
    let sevenDayChange: Double?
    let sevenDaySales: Double?
    let sevenDayAveragePrice: Double?
    
    let thirtyDayVolume: Double?
    let thirtyDayChange: Double?
    let thirtyDaySales: Double?
    let thirtyDayAveragePrice: Double?
    
    let totalVolume: Double?
    let totalSales: Double?
    let totalSupply: Double?
    
    let count: Double?
    let numOwners: Int?
    
    let averagePrice: Double?
    let marketCap: Double?
    let floorPrice: Double?
}


extension CollectionStats: Decodable {
    enum CodingKeys: String, CodingKey {
        case oneDayVolume = "one_day_volume"
        case oneDayChange = "one_day_change"
        case oneDaySales = "one_day_sales"
        case oneDayAveragePrice = "one_day_average_price"
        
        case sevenDayVolume = "seven_day_volume"
        case sevenDayChange = "seven_day_change"
        case sevenDaySales = "seven_day_sales"
        case sevenDayAveragePrice = "seven_day_average_price"
        
        case thiryDayVolume = "thiry_day_volume"
        case thiryDayChange = "thiry_day_change"
        case thiryDaySales = "thiry_day_sales"
        case thirtyDayAveragePrice = "thiry_day_average_price"
        
        case totalVolume = "total_volume"
        case totalSales = "total_sales"
        case totalSupply = "total_supply"
     
        case count = "count"
        case numOwners = "num_owners"
        
        case averagePrice = "average_price"
        case marketCap = "market_cap"
        case floorPrice = "floor_price"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        oneDayVolume = (try? container.decode(Double.self, forKey: .oneDayVolume)) ?? nil
        oneDayChange = (try? container.decode(Double.self, forKey: .oneDayChange)) ?? nil
        oneDaySales = (try? container.decode(Double.self, forKey: .oneDaySales)) ?? nil
        oneDayAveragePrice = (try? container.decode(Double.self, forKey: .oneDayAveragePrice)) ?? nil
        
        sevenDayVolume = (try? container.decode(Double.self, forKey: .sevenDayVolume)) ?? nil
        sevenDayChange = (try? container.decode(Double.self, forKey: .sevenDayChange)) ?? nil
        sevenDaySales = (try? container.decode(Double.self, forKey: .sevenDaySales)) ?? nil
        sevenDayAveragePrice = (try? container.decode(Double.self, forKey: .sevenDayAveragePrice)) ?? nil
        
        thirtyDayVolume = (try? container.decode(Double.self, forKey: .thiryDayVolume)) ?? nil
        thirtyDayChange = (try? container.decode(Double.self, forKey: .thiryDayChange)) ?? nil
        thirtyDaySales = (try? container.decode(Double.self, forKey: .thiryDaySales)) ?? nil
        thirtyDayAveragePrice = (try? container.decode(Double.self, forKey: .thirtyDayAveragePrice)) ?? nil
        
        totalVolume = (try? container.decode(Double.self, forKey: .totalVolume)) ?? nil
        totalSales = (try? container.decode(Double.self, forKey: .totalSales)) ?? nil
        totalSupply = (try? container.decode(Double.self, forKey: .totalSupply)) ?? nil
        
        count = (try? container.decode(Double.self, forKey: .count)) ?? nil
        numOwners = (try? container.decode(Int.self, forKey: .numOwners)) ?? nil
        
        averagePrice = (try? container.decode(Double.self, forKey: .averagePrice)) ?? nil
        marketCap = (try? container.decode(Double.self, forKey: .marketCap)) ?? nil
        floorPrice = (try? container.decode(Double.self, forKey: .floorPrice)) ?? nil
    }
}


// MARK: Payment Token

struct PaymentToken: Identifiable, Hashable {
    
    let id: String
    let symbol: String
    let address: String
    
    let title: String?
    let imageUrl: URL?
    
    let decimals: Int?
    
    let ethPrice: Double?
    let usdPrice: Double?
}

extension PaymentToken: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case symbol = "symbol"
        case address = "address"
        case title = "name"
        case imageUrl = "image_url"
        case decimals = "decimals"
        case ethPrice = "eth_price"
        case usdPrice = "usd_price"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try String(container.decode(Int.self, forKey: .id))
        symbol = try container.decode(String.self, forKey: .symbol)
        address = try container.decode(String.self, forKey: .address)

        title = (try? container.decode(String.self, forKey: .title)) ?? nil
        imageUrl = (try? URL(string: container.decode(String.self, forKey: .imageUrl))) ?? nil
        
        decimals = (try? container.decode(Int.self, forKey: .decimals)) ?? nil
        
        ethPrice = (try? container.decode(Double.self, forKey: .ethPrice)) ?? nil
        usdPrice = (try? container.decode(Double.self, forKey: .usdPrice)) ?? nil
    }
    
}


// MARK: Trait

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


// MARK: Creator


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


// MARK: User

struct User: Hashable {
    let username: String
}


extension User: Decodable {}


// MARK: Asset

struct Asset: Identifiable, Hashable {
    let id: String
    
    let tokenId: String
    
    let title: String?
    let text: String?
    
    let backgroundColor: UIColor?
    
    let permalink: URL?
    let externalLink: URL?
    
    let imageThumbnailUrl: URL?
    
    let imageUrl: URL?
    let imageOriginalUrl: URL?
    
    let animationUrl: URL?
    let animationOriginalUrl: URL?
    
    let tokenMetadata: URL?
    
    let contract: Contract
    let creator: Creator?
    let traits: [Trait]?
    let collection: Collection?

    let deepLink: URL
}

extension Asset: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tokenId = "token_id"
        case title = "name"
        case text = "description"
        case backgroundColor = "background_color"
        case permalink = "permalink"
        case externalLink = "external_link"
        case imageThumbnailUrl = "image_thumbnail_url"
        case imageUrl = "image_url"
        case imageOriginalUrl = "image_original_url"
        case animationUrl = "animation_url"
        case animationOriginalUrl = "animation_original_url"
        case tokenMetadata = "token_metadata"
        case contract = "asset_contract"
        case traits = "traits"
        case creator = "creator"
        case collection = "collection"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try String(container.decode(Int.self, forKey: .id))
        tokenId = try container.decode(String.self, forKey: .tokenId)
        
        title = (try? container.decode(String.self, forKey: .title)) ?? nil
        text = (try? container.decode(String.self, forKey: .text)) ?? nil
        
        let backgroundColorHex = (try? container.decode(String.self, forKey: .backgroundColor)) ?? nil
        backgroundColor = backgroundColorHex != nil ? UIColor(hexString: backgroundColorHex) : UIColor.clear
        
        permalink = (try? URL(string: container.decode(String.self, forKey: .permalink))) ?? nil
        externalLink = (try? URL(string: container.decode(String.self, forKey: .externalLink))) ?? nil
        
        imageThumbnailUrl = (try? URL(string: container.decode(String.self, forKey: .imageThumbnailUrl))) ?? nil
        
        imageUrl = (try? URL(string: container.decode(String.self, forKey: .imageUrl))) ?? nil
        imageOriginalUrl = (try? URL(string: container.decode(String.self, forKey: .imageOriginalUrl))) ?? nil
        
        animationUrl = (try? URL(string: container.decode(String.self, forKey: .animationUrl))) ?? nil
        animationOriginalUrl = (try? URL(string: container.decode(String.self, forKey: .animationOriginalUrl))) ?? nil
        
        tokenMetadata = (try? URL(string: container.decode(String.self, forKey: .tokenMetadata))) ?? nil
        
        contract = try container.decode(Contract.self, forKey: .contract)
        
        traits = (try? container.decode([Trait].self, forKey: .traits)) ?? nil
        
        creator = (try? container.decode(Creator.self, forKey: .creator)) ?? nil
        
        collection = (try? container.decode(Collection.self, forKey: .collection)) ?? nil
        
        deepLink = URL(string: "canvas://\(contract.address)/\(tokenId)")!
    }
}

