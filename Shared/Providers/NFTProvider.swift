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
    static func fetchNFTs(
        ownerAddress: String,
        strategy: DataStrategies = .Alchemy
    ) async throws -> [NFT] {
        
        var list: [NFT] = [NFT]()
        
        switch strategy {
        case .Alchemy:
            list = try! await APIAlchemyProvider.fetchNFTs(ownerAddress: ownerAddress)
        }
 
        return list
    }
    
    
    static func fetchNFT(contractAddress: String, tokenId: String, strategy: DataStrategies = .Alchemy) async throws -> NFT? {
        switch strategy {
        case .Alchemy:
            return try! await APIAlchemyProvider.fetchNFT(contractAddress: contractAddress, tokenId: tokenId)
        }
    }
    
    static func fetchRandomNFT(ownerAddress: String) async throws -> NFT {
        do {
            let items = try await fetchNFTs(ownerAddress: ownerAddress)
            
            let randomIndex = Int.random(in: 0..<items.count)
            
            return items[randomIndex]
        
        } catch {
            print("⚠️ NFTProvider::fetchRandomNFT: \(error)")
            
            throw APIError.BadResponse
        }
    }
    
}
