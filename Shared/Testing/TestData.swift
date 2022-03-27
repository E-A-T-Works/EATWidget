//
//  TestData.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import UIKit

struct TestData {
    
    static let collection: Collection = Collection(
        id: "0x0000000000000000",
        address: "0x0000000000000000",
        title: "Every Icon",
        text: "A re-imagining of Every Icon, John F. Simon Jr.'s seminal web-based software art work first released in 1997.  This blockchain-native, on-chain expression was created by John F. Simon Jr. and divergence, in collaboration with FingerprintsDAO and e•a•t•}works",
        links: [ExternalLink](),
        banner: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2F0xf9a423b86afbf8db41d7f24fa56848f56684e43f%2Fbanner.png?alt=media&token=e6f96e72-067e-4c02-bcbe-c5f0d0288e20")!,
        thumbnail: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2F0xf9a423b86afbf8db41d7f24fa56848f56684e43f%2Fthumbnail.png?alt=media&token=17039284-d6ab-4371-bbd3-23b76960dd06")!
    )
    
    static let nft: NFT = NFT(
        id: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5/0x0000000000000000000000000000000000000000000000000000000000000d2c",
        address: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5",
        tokenId: "0x0000000000000000000000000000000000000000000000000000000000000d2c",
        standard: "ERC721",
        title: "#3372 Janky",
        text: "0x066f2d5ead7951f0d0038c19affd500b9f02c0e5",
        image: UIImage(named: "Placeholder")!,
        simulationUrl: nil,
        animationUrl: URL(string: "https://res.cloudinary.com/nifty-gateway/video/upload/v1613068880/A/SuperPlastic/Kranky_Metal_As_Fuck_Black_Edition_Superplastic_X_SketOne_wyhzcf_hivljh.mp4"),
        
        twitterUrl: nil,
        discordUrl: nil,
        openseaUrl: nil,
        externalUrl: nil,
        metadataUrl: nil,
        
        attributes: [
            Attribute(key: "Drop", value: "Episode 1: The Janky Heist"),
            Attribute(key: "JankyID", value: "3372"),
            Attribute(key: "Head", value: "WHACKULA Head"),
            Attribute(key: "Body", value: "STANK Body"),
            Attribute(key: "Shoe", value: "SHüDOG-BRED Shoe"),
            Attribute(key: "Jankyness Level", value: "Level 7"),
            Attribute(key: "Background", value: "Normal"),
            Attribute(key: "Artist", value: "Janky & Guggimon"),
            Attribute(key: "Type", value: "Normie")
        ]
    )
}
