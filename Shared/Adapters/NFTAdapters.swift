//
//  NFTAdapters.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation
import SwiftUI


final class NFTAdapters {
    
    static func mapAlchemyDataToNFTs(list: [APIAlchemyNFT]) async -> [NFT] {
        
        do {
            var parsed = [NFT?]()
            var cleaned = [NFT]()
            
            parsed = try await list.concurrentMap { (item: APIAlchemyNFT) -> NFT? in
                
                do {
                    print("➡️ \(item.contract.address) \(item.id.tokenId)")
                    
                    guard let rawMetadata = item.metadata else { return nil }
                    
                    let metadata = await mapMetadata(address: item.contract.address, data: rawMetadata)
                    
                    guard let imageUrl = item.media.first?.gateway ?? item.media.first?.raw ?? metadata.imageUrl else {
                        return nil
                    }
                    
                    let imageData = try Data(contentsOf: imageUrl)
                    
                    // enforce 10mb size limit
                    if imageData.count > (10 * 1_000_000) { return nil }
                    
                    guard let image = UIImage(data: imageData) else { return nil }
                    
                    print(imageData)
                    
                    return NFT(
                        id: "\(item.contract.address)/\(item.id.tokenId)",
                        address: item.contract.address,
                        tokenId: item.id.tokenId,
                        standard: item.id.tokenMetadata.tokenType,
                        title: item.title,
                        text: item.text,
                        image: image,
                        animationUrl: item.metadata?.animationUrl,
                        externalURL: item.tokenUri.gateway ?? item.tokenUri.raw,
                        traits: []
                    )
                } catch {
                    print("⚠️ NFTAdapters:mapAlchemyDataToNFTs \(item.contract.address) \(item.id.tokenId) \(error)")
                    return nil
                }
            }
                        
            cleaned = parsed.compactMap { $0 }
            
            return cleaned
        } catch {
            print("⚠️ NFTAdapters:mapAlchemyDataToNFTs \(error)")

            return [NFT]()
        }
    }
    
    static func mapMetadata(address: String, data: APIAlchemyMetadata) async -> APIAlchemyMetadata {
        
        switch address {
        case "0xf9a423b86afbf8db41d7f24fa56848f56684e43f":
            return await mapEveryIconMetaData(data: data)
        default:
            return data
        }
    }
    
    
    static func mapEveryIconMetaData(data: APIAlchemyMetadata) async -> APIAlchemyMetadata {
        return data
    }
    
}
