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
                return await normalize(address: item.contract.address, item: item)
            }
                        
            cleaned = parsed.compactMap { $0 }
            
            return cleaned
        } catch {
            print("⚠️ NFTAdapters:mapAlchemyDataToNFTs \(error)")

            return [NFT]()
        }
    }
    
    static private func normalize(address: String, item: APIAlchemyNFT) async -> NFT? {
        print("➡️ \(item.contract.address) \(item.id.tokenId) \(item.title)")
        switch address {
        case "0xf9a423b86afbf8db41d7f24fa56848f56684e43f":
            return await normalizeEveryIcon(item: item)
        default:
            return await normalizeAlchemyNFT(item: item)
        }
    }
    
    
    static private func normalizeAlchemyNFT(item: APIAlchemyNFT) async -> NFT? {
        do {
            guard let imageUrl = item.media.first?.gateway ?? item.media.first?.raw else {
                return nil
            }
            
            let imageData = try Data(contentsOf: imageUrl)
            
            // enforce 10mb size limit
            if imageData.count > (10 * 1_000_000) { return nil }
            
            guard let image = UIImage(data: imageData) else { return nil }

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
            print("⚠️ normalizeAlchemyNFT \(item.contract.address) \(item.id.tokenId) \(error)")
            return nil
        }
    }
    
    ///
    /// EveryIcon has the entire SVG written in the image field
    /// image: data:image/svg+xml,<svg width='512' height='512'>...</svg>
    ///
    /// We need to parse it, write it to a temporary file so we can read it and use PocketSVG
    /// to convert it to a UIImage and save it to a temporary
    ///
    static private func normalizeEveryIcon(item: APIAlchemyNFT) async -> NFT? {
        
        do {
           
            guard let metadata = item.metadata else { return nil }
            
            guard let svg = metadata.image?.replacingOccurrences(of: "data:image/svg+xml,", with: "").replacingOccurrences(of: "width='512' height='512'", with: "viewBox='0 0 512 512'") else { return nil }
            
            
            print(svg)
    
//            let data = try svg.data(using: .utf8)
//            let image = SVGKImage(data: data).uiImage!
//
//            if let data = response.data {
//                if let image = SVGKImage(data: data) {
//                   if let uiImageInstance = image.uiImage {
//                       self.userImageView.image = uiImageInstance
//                   }
//                }
//            }
    
            let image = UIImage(systemName: "plus")!

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
            print("⚠️ normalizeEveryIcon \(item.contract.address) \(item.id.tokenId) \(error)")
            return nil
        }
    }
    
    
    
    

    
}
