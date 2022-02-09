//
//  TestData.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation

struct JSONTestData:Decodable {
    let results: [Asset]
}

struct TestData {
    static let assets: [Asset] = { () -> [Asset] in
        let url = Bundle.main.url(forResource: "sample-nft", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let payload = try! decoder.decode(JSONTestData.self, from: data)
        
        return payload.results
    }()
    
    static let asset: Asset = { () -> Asset in
    
        return TestData.assets.first!
    }()
}
