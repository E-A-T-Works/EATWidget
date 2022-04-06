//
//  APIEnsideasProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 4/6/22.
//

import Foundation
import UIKit


final class APIEnsideasProvider {
    init() {}
    
    func resolve(for ensAddress: String) async throws -> String {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.ensideas.com"
        components.path = "/ens/resolve/\(ensAddress)"
        components.queryItems = []
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }
        
        do {
            let _request = URLRequest(url: url)
            
            let request = APIRequest(request: _request)
            let response = try await request.perform(ofType: APIEnsideasGetResponse.self)

            return response.address
            
            
        } catch { throw APIError.BadResponse }
    }
    
}
