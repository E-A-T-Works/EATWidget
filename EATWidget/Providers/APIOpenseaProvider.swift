//
//  APIOpenseaProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/30/22.
//

import Foundation

final class APIOpenseaProvider {
    static let shared: APIOpenseaProvider = APIOpenseaProvider()
    
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
    
}
