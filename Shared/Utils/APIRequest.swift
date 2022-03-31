//
//  APIRequest.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//
//  References:
//      https://matteomanferdini.com/network-requests-rest-apis-ios-swift/
//      https://www.avanderlee.com/swift/async-await/
//      https://wwdcbysundell.com/2021/using-async-await-with-urlsession/
//

import Foundation

class APIRequest {
    
    let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func perform<T: Decodable>(ofType: T.Type) async throws -> T {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let (data, _) = try await session.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(T.self, from: data)
    }
    
    func perform<T: Decodable>(with completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)

        let task = session.dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            completion(try? decoder.decode(T.self, from: data))
        }

        task.resume()
    }
}
