//
//  APIAlchemyProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation


final class APIAlchemyProvider {
    static func fetchNFTs(ownerAddress: String, filterOutUnsupported: Bool = true) async throws -> [NFT] {
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

            let list = response.ownedNfts.filter {
                if !filterOutUnsupported {
                    return true
                }
                
                return $0.isSupported
                
            }.map { (item: APIAlchemyNFT) -> NFT in
                return NFT(
                    id: "\(item.contract.address)/\(item.id.tokenId)",
                    address: item.contract.address,
                    tokenId: item.id.tokenId,
                    standard: item.id.tokenMetadata.tokenType,
                    title: item.title,
                    text: item.text,
                    imageUrl: item.media.first?.uri.gateway,
                    thumbnailUrl: nil,
                    animationUrl: nil,
                    externalURL: nil,
                    creator: nil,
                    collection: nil,
                    traits: (item.metadata?.attributes ?? []).filter {
                        $0.traitType != nil && $0.value != nil
                    }.map { (attribute: APIAlchemyAttribute) -> NFTTrait in
                        NFTTrait(key: attribute.traitType!, value: attribute.value!)
                    }
                )
            }

            return list
        } catch {
            print("⚠️ APIAlchemyProvider::fetchNFTs: \(error)")
            
            throw APIError.BadResponse
        }
    }
    
    static func fetchNFT(contractAddress: String, tokenId: String) async throws -> NFT? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_ALCHEMY") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("⚠️ APIAlchemyProvider::fetchNFTs: Missing API Key")
            throw APIError.MissingKey
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "eth-mainnet.alchemyapi.io"
        components.path = "/v2/\(key)/getNFTMetadata"
        components.queryItems = [
            URLQueryItem(name: "contractAddress", value: contractAddress),
            URLQueryItem(name: "tokenId", value: tokenId),
       ]
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }
        
        do {
            let request = APIRequest(url: url)
            
            let item = try await request.perform(ofType: APIAlchemyNFT.self)

            return NFT(
                id: "\(item.contract.address)/\(item.id.tokenId)",
                address: item.contract.address,
                tokenId: item.id.tokenId,
                standard: item.id.tokenMetadata.tokenType,
                title: item.title,
                text: item.text,
                imageUrl: item.media.first?.uri.gateway,
                thumbnailUrl: nil,
                animationUrl: nil,
                externalURL: item.tokenUri.gateway,
                creator: nil,
                collection: nil,
                traits: (item.metadata?.attributes ?? []).filter {
                    $0.traitType != nil && $0.value != nil
                }.map { (attribute: APIAlchemyAttribute) -> NFTTrait in
                    NFTTrait(key: attribute.traitType!, value: attribute.value!)
                }
            )
        } catch {
            print("⚠️ APIAlchemyProvider::fetchNFT: \(error)")
            
            throw APIError.BadResponse
        }
    }
}
