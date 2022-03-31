//
//  APIAlchemyProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation
import UIKit


final class APIAlchemyProvider {
    static let shared: APIAlchemyProvider = APIAlchemyProvider()
    
    var nfts: [API_NFT] = [API_NFT]()
    
    func getNFTs(for ownerAddress: String) async throws -> [API_NFT] {
        clearResults()
        
        let key = try resolveKey()
        
        try await performAPICall(for: "/v2/\(key)/getNFTs", owner: ownerAddress)
        
        return nfts
    }
    
    
    // MARK: - Private
    
    private func resolveKey() throws -> String {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_ALCHEMY") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("⚠️ APIAlchemyProvider::resolveKey: Missing API Key")
            throw APIError.MissingKey
        }
        
        return key
    }
    
    private func clearResults() {
        nfts =  [API_NFT]()
    }
    
    private func performAPICall(for path: String, owner: String, pageKey: String? = nil) async throws {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "eth-mainnet.alchemyapi.io"
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "owner", value: owner),
            URLQueryItem(name: "withMetadata", value: "true")
       ]
        
        if pageKey != nil {
            components.queryItems?.append(URLQueryItem(name: "pageKey", value: pageKey))
        }
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }
        
        do {
            let _request = URLRequest(url: url)
            
            let request = APIRequest(request: _request)
            let response = try await request.perform(ofType: APIAlchemyGetNFTsResponse.self)
            
            let list = response.ownedNfts.map { raw in
                return API_NFT(
                    id: "\(raw.contract.address)/\(raw.id.tokenId)",
                    address: raw.contract.address,
                    tokenId: raw.id.tokenId,
                    collection: nil,
                    title: raw.title,
                    text: raw.text,
                    imageUrl: nil,
                    animationUrl: nil,
                    metadataUrl: nil,
                    permalink: nil,
                    attributes: [API_NFT_Attribute]()
                )
                
            }
            
            self.nfts.append(contentsOf: list)
            
            guard let nextPageKey = response.pageKey else {
                return
            }

            try await performAPICall(for: path, owner: owner, pageKey: nextPageKey)
            
        } catch { throw APIError.BadResponse }
    }
}
