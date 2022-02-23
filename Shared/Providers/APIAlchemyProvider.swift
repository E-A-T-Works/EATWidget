//
//  APIAlchemyProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation
import UIKit


final class APIAlchemyProvider {
    static func fetchNFTs(ownerAddress: String) async throws -> [NFT] {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_ALCHEMY") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("⚠️ APIAlchemyProvider::fetchNFTs: Missing API Key")
            throw APIError.MissingKey
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "eth-mainnet.alchemyapi.io"
        components.path = "/v2/\(key)/getNFTs"
        components.queryItems = [
            URLQueryItem(name: "owner", value: ownerAddress),
            URLQueryItem(name: "withMetadata", value: "true")
       ]
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }
        
        do {
            let request = APIRequest(url: url)
            
            let response = try await request.perform(ofType: APIAlchemyGetNFTsResponse.self)
            
            let suported = response.ownedNfts.filter {
                $0.isSupported
            }
            
            let list: [NFT?] = await suported.asyncMap { (item: APIAlchemyNFT) -> NFT? in
                
                guard let imageUrl = item.media.first?.gateway else { return nil }
                
                guard let imageData = try? Data(contentsOf: imageUrl) else { return nil }
                
                // enforce 10mb size limit
                if imageData.count > (10 * 1_000_000) { return nil }
                
                return NFT(
                    id: "\(item.contract.address)/\(item.id.tokenId)",
                    address: item.contract.address,
                    tokenId: item.id.tokenId,
                    standard: item.id.tokenMetadata.tokenType,
                    title: item.title,
                    text: item.text,
                    image: UIImage(data: imageData)!,
                    animationUrl: item.metadata?.animationUrl,
                    externalURL: nil,
                    traits: []
                )
                
            }
                
            let cleanedList: [NFT] = list.compactMap{ $0 }
                
//            .map { (item: APIAlchemyNFT) -> NFT in
//                NFT(
//                    id: "\(item.contract.address)/\(item.id.tokenId)",
//                    address: item.contract.address,
//                    tokenId: item.id.tokenId,
//                    standard: item.id.tokenMetadata.tokenType,
//                    title: item.title,
//                    text: item.text,
//                    imageUrl: item.media.first?.gateway,
//                    thumbnailUrl: item.metadata?.thumbnailUrl,
//                    animationUrl: item.metadata?.animationUrl,
//                    externalURL: nil,
//                    traits: (item.metadata?.attributes ?? []).filter {
//                        $0.traitType != nil && $0.value != nil
//                    }.map { (attribute: APIAlchemyAttribute) -> NFTTrait in
//                        NFTTrait(key: attribute.traitType!, value: attribute.value!)
//                    }
//                )
//            }

            return cleanedList
        } catch {
            print("⚠️ APIAlchemyProvider::fetchNFTs: \(error)")
            
            throw APIError.BadResponse
        }
    }
    
    static func fetchNFT(contractAddress: String, tokenId: String) async throws -> NFT? {
//        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_ALCHEMY") as? String
//        guard let key = apiKey, !key.isEmpty else {
//            print("⚠️ APIAlchemyProvider::fetchNFTs: Missing API Key")
//            throw APIError.MissingKey
//        }
//
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "eth-mainnet.alchemyapi.io"
//        components.path = "/v2/\(key)/getNFTMetadata"
//        components.queryItems = [
//            URLQueryItem(name: "contractAddress", value: contractAddress),
//            URLQueryItem(name: "tokenId", value: tokenId),
//       ]
//
//        guard let url = components.url else {
//            throw APIError.InvalidUrl
//        }
        
//        do {
//            let request = APIRequest(url: url)
//
//            let item = try await request.perform(ofType: APIAlchemyNFT.self)
//
//            return NFT(
//                id: "\(item.contract.address)/\(item.id.tokenId)",
//                address: item.contract.address,
//                tokenId: item.id.tokenId,
//                standard: item.id.tokenMetadata.tokenType,
//                title: item.title,
//                text: item.text,
//                imageUrl: item.media.first?.gateway,
//                thumbnailUrl: nil,
//                animationUrl: nil,
//                externalURL: item.tokenUri.gateway,
//                traits: (item.metadata?.attributes ?? []).filter {
//                    $0.traitType != nil && $0.value != nil
//                }.map { (attribute: APIAlchemyAttribute) -> NFTTrait in
//                    NFTTrait(key: attribute.traitType!, value: attribute.value!)
//                }
//            )
//        } catch {
//            print("⚠️ APIAlchemyProvider::fetchNFT: \(error)")
//
//            throw APIError.BadResponse
//        }
        
        return nil
    }
}
