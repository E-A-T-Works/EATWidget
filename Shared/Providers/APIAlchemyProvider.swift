//
//  APIAlchemyProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation


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

            let list = response.ownedNfts.filter {
                let media = $0.media.first
                
                if media == nil || media?.uri.raw == nil || media?.uri.gateway == nil {
                    return false
                }

                return true
            }.map { (item: APIAlchemyNFT) -> NFT in
                return NFT(
                    id: item.id.tokenId,
                    address: item.contract.address,
                    title: item.title,
                    text: item.text,
                    imageUrl: item.media.first?.uri.gateway,
                    thumbnailUrl: nil,
                    animationUrl: nil,
                    externalURL: nil,
                    creator: nil,
                    traits: (item.metadata?.attributes ?? []).filter {
                        $0.traitType != nil && $0.value != nil
                    }.map { (attribute: APIAlchemyAttribute) -> NFTTrait in
                        NFTTrait(key: attribute.traitType!, value: attribute.value!)
                    }
                )
            }

            return list
        } catch {
            print("⚠️ APIAlchemyProvider::fetchAssets: \(error)")
            
            throw APIError.BadResponse
        }
    }
    
    static func fetchNFT(ownerAddress: String) async throws{
        // TODO:
        

        
    }
}
