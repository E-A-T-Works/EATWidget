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
    
    static let nft: NFT = NFT(
        id: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5/0x0000000000000000000000000000000000000000000000000000000000000d2c",
        address: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5",
        tokenId: "0x0000000000000000000000000000000000000000000000000000000000000d2c",
        standard: "ERC721",
        title: "#3372 Janky",
        text: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5",
        imageUrl: URL(string: "https://nfts.superplastic.co/images/3372.png"),
        thumbnailUrl: nil,
        animationUrl: nil,
        externalURL: nil,
        creator: nil,
        collection: nil,
        traits: [
            NFTTrait(key: "Drop", value: "Episode 1: The Janky Heist"),
            NFTTrait(key: "JankyID", value: "3372"),
            NFTTrait(key: "Head", value: "WHACKULA Head"),
            NFTTrait(key: "Body", value: "STANK Body"),
            NFTTrait(key: "Shoe", value: "SHüDOG-BRED Shoe"),
            NFTTrait(key: "Jankyness Level", value: "Level 7"),
            NFTTrait(key: "Background", value: "Normal"),
            NFTTrait(key: "Artist", value: "Janky & Guggimon"),
            NFTTrait(key: "Type", value: "Normie")
        ]
    )
}
