//
//  APIAlchemyProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation
import UIKit


final class APIAlchemyProvider {
    static func fetchNFTs(ownerAddress: String) async throws -> [APIAlchemyNFT] {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_ALCHEMY") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("⚠️ APIAlchemyProvider::fetchNFTs: Missing API Key")
            throw APIError.MissingKey
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "eth-mainnet.alchemyapi.io"
        components.path = "/v2/\(key)/getNFTs"
        components.queryItems = [
            URLQueryItem(name: "owner", value: ownerAddress),
            URLQueryItem(name: "withMetadata", value: "true")
       ]
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }
        
        do {
            let request = APIRequest(url: url)
            
            let response = try await request.perform(ofType: APIAlchemyGetNFTsResponse.self)
            
            print(response)

            return response.ownedNfts

        } catch {
            print("⚠️ APIAlchemyProvider::fetchNFTs: \(error)")
            
            throw APIError.BadResponse
        }
    }
    
    static func fetchNFT(contractAddress: String, tokenId: String) async throws -> NFT? {
        
        // TODO: Implement
        
        return nil
    }
}
