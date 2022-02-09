//
//  DataProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//
//  References:
//      https://docs.etherscan.io/api-endpoints/accounts
//

import Foundation


final class DataProvider {
    
    static func fetchWalletBalance(address: String) async throws -> String {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rinkeby-api.opensea.io"
        components.path = "/api/v1/assets"
        components.queryItems = [
            URLQueryItem(name: "module", value: "account"),
            URLQueryItem(name: "action", value: "balance"),
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "tag", value: "latest"),
            URLQueryItem(name: "apiKey", value: "AIGTQC6I35XHC132KY4UKEGXRFEAJ16XQ6")
       ]
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }

        do {
            let request = APIRequest(url: url)
            
            let response = try await request.perform(ofType: EtherscanAccountBalanceResponse.self)
            
            let balance = response.result

            return balance
        } catch {
            print("⚠️ DataProvider::fetchWalletBalance: \(error)")
            
            throw APIError.BadResponse
        }
    }
    
    
}
