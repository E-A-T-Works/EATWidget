//
//  TestData.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation

struct TestData {
    static let asset: Asset = {
        let url = Bundle.main.url(forResource: "sample-nft", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try! decoder.decode(Asset.self, from: data)
    }()
}
