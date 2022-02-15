//
//  NFTProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation


enum DataStrategies {
    case Alchemy
}

final class NFTProvider {
    static func fetchNFTs(ownerAddress: String, stratey: DataStrategies = .Alchemy) async throws -> [NFT] {
        switch stratey {
        case .Alchemy:
            return try! await APIAlchemyProvider.fetchNFTs(ownerAddress: ownerAddress)
        }
    }
    
    
    static func fetchNFT(contractAddress: String, tokenId: String, stratey: DataStrategies = .Alchemy) async throws -> NFT? {
        switch stratey {
        case .Alchemy:
            return try! await APIAlchemyProvider.fetchNFT(contractAddress: contractAddress, tokenId: tokenId)
        }
    }
    
}
