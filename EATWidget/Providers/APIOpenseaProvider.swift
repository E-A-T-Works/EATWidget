//
//  APIOpenseaProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/30/22.
//

import Foundation

final class APIOpenseaProvider {
    static let shared: APIOpenseaProvider = APIOpenseaProvider()
    
    var nfts: [APIOpenSeaNFT] = [APIOpenSeaNFT]()
    
    func getNFTs(for ownerAddress: String) async throws -> [APIOpenSeaNFT] {
        clearResults()
        
        try await performAPICall(for: "/api/v1/assets", owner: ownerAddress)
        
        return nfts
    }
    
    init() {}
    
    // MARK: - Private
    
    private func resolveKey() throws -> String {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_OPENSEA") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("⚠️ APIOpenseaProvider::resolveKey: Missing API Key")
            throw APIError.MissingKey
        }
        
        return key
    }
    
    private func clearResults() {
        nfts =  [APIOpenSeaNFT]()
    }
    
    
    private func performAPICall(for path: String, owner: String, cursor: String? = nil) async throws {
        
        let key = try resolveKey()

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.opensea.io"
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "owner", value: owner),
            URLQueryItem(name: "limit", value: "50")
       ]
        
        
        if cursor != nil {
            components.queryItems?.append(URLQueryItem(name: "cursor", value: cursor))
        }
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }
        
        do {
            var _request = URLRequest(url: url)
            _request.setValue(key, forHTTPHeaderField: "X-API-KEY")
            
            let request = APIRequest(request: _request)
            
            let response = try await request.perform(ofType: APIOpenSeaGetNFTsResponse.self)
            
            print(response)
            
//            let list = response.assets
//
//            self.nfts.append(contentsOf: list)
            
            guard let nextCursor = response.next else {
                return
            }

            try await performAPICall(for: path, owner: owner, cursor: nextCursor)
            
        } catch {
            print("⚠️ APIOpenseaProvider \(error)")
            throw APIError.BadResponse
        }
    }
    
}
