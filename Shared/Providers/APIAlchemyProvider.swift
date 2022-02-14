//
//  APIAlchemyProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation


final class APIAlchemyProvider {
    static func fetchNFTs(ownerAddress: String) async throws -> [NFT] {
        // TODO:
        print("boop")
        
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "rinkeby-api.opensea.io"
//        components.path = "/api/v1/assets"
//        components.queryItems = [
//            URLQueryItem(name: "owner", value: ownerAddress),
//            URLQueryItem(name: "offset", value: "0"),
//            URLQueryItem(name: "limit", value: "25"),
//            URLQueryItem(name: "order_direction", value: "desc")
//       ]
//
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_ALCHEMY") as? String
        
        print("!!!!!!")
        
        print("APIAlchemyProvider: fetchNFT: \(apiKey ?? "NOT FOUND")")
        
        return [NFT]()
    }
    
    static func fetchNFT(ownerAddress: String) async throws{
        // TODO:
        

        
    }
}
