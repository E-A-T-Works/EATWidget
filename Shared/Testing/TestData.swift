//
//  TestData.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import UIKit

struct TestData {
    static let nft: NFT = NFT(
        id: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5/0x0000000000000000000000000000000000000000000000000000000000000d2c",
        address: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5",
        tokenId: "0x0000000000000000000000000000000000000000000000000000000000000d2c",
        standard: "ERC721",
        title: "#3372 Janky",
        text: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5",
        image: UIImage(named: "eat-b-1-0")!,
        animationUrl: nil,
        externalURL: nil,
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
