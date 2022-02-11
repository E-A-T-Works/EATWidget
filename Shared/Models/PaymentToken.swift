//
//  PaymentToken.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/10/22.
//

import Foundation


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
