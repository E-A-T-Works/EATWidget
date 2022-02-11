//
//  Collection.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/10/22.
//

import Foundation


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
