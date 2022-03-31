//
//  APIOpenseaProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/30/22.
//

import Foundation

final class APIOpenseaProvider {

    var contract: APIContract?
    var nfts: [API_NFT] = [API_NFT]()
    
    init() {}
    
    func getNFTs(for ownerAddress: String) async throws -> [API_NFT] {
        nfts =  [API_NFT]()
        
        try await performGetNFTsCall(for: ownerAddress)
        
        return nfts
    }
    
    func getNFT(address: String, tokenId: String) async throws -> API_NFT? {
        return nil
    }
    
    func getContract(for address: String) async throws -> APIContract? {
        contract = nil
        
        try await performGetAContractCall(for: address)
        
        return contract
    }
    
    // MARK: - Private
    
    private func resolveKey() throws -> String {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY_OPENSEA") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("⚠️ APIOpenseaProvider::resolveKey: Missing API Key")
            throw APIError.MissingKey
        }
        
        return key
    }
    
    private func performGetNFTsCall(for owner: String, cursor: String? = nil) async throws {
        
        let key = try resolveKey()

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.opensea.io"
        components.path =  "/api/v1/assets"
        components.queryItems = [
            URLQueryItem(name: "owner", value: owner),
            URLQueryItem(name: "limit", value: "50")
       ]
        
        
        if cursor != nil {
            components.queryItems?.append(URLQueryItem(name: "cursor", value: cursor))
        }
        
        guard let url = components.url else {
            throw APIError.InvalidUrl
        }
        
        do {
            var _request = URLRequest(url: url)
            _request.setValue(key, forHTTPHeaderField: "X-API-KEY")
            
            let request = APIRequest(request: _request)
            
            let response = try await request.perform(ofType: APIOpenSeaGetNFTsResponse.self)
                        
            let list = response.assets.map { raw -> API_NFT in
                return API_NFT(
                    id: "\(raw.contract.address)/\(raw.tokenId)",
                    address: raw.contract.address,
                    tokenId: raw.tokenId,
                    title: raw.title,
                    text: raw.text,
                    imageUrl: raw.imageUrl,
                    animationUrl: raw.animationUrl,
                    metadataUrl: raw.metadataUrl,
                    permalink: raw.permalink,
                    attributes: raw.attributes.map {
                        API_NFT_Attribute(key: $0.traitType, value: $0.value)
                    }
                )
            }

            self.nfts.append(contentsOf: list)
            
            guard let nextCursor = response.next else {
                return
            }

            try await performGetNFTsCall(for: owner, cursor: nextCursor)
            
        } catch {
            print("⚠️ APIOpenseaProvider \(error)")
            throw APIError.BadResponse
        }
    }
    
    
    private func performGetAContractCall(for address: String) async throws {
        
        let key = try resolveKey()

//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "api.opensea.io"
//        components.path =  "api/v1/asset_contract/\(address)"
//        components.queryItems = []
//
//        guard let url = components.url else {
//            throw APIError.InvalidUrl
//        }

        guard let url = URL(string:"https://api.opensea.io/api/v1/asset_contract/\(address)") else {
            throw APIError.InvalidUrl
        }
        
        do {
            var _request = URLRequest(url: url)
            _request.setValue(key, forHTTPHeaderField: "X-API-KEY")

            let request = APIRequest(request: _request)

            let response = try await request.perform(ofType: APIOpenSeaGetContractResponse.self)

            guard let collection = response.collection else {
                throw APIError.BadResponse
            }

            contract = APIContract(
                id: address,
                address: address,
                collection: APICollection(
                    id: address,
                    address: address,
                    title: collection.title,
                    text: collection.text,
                    thumbnailUrl: collection.thumbnailUrl,
                    bannerUrl: collection.bannerUrl,
                    chatUrl: collection.chatUrl,
                    discordUrl: collection.discordUrl,
                    telegramUrl: collection.telegramUrl,
                    wikiUrl: collection.wikiUrl,
                    externalUrl: collection.externalUrl,
                    twitterUsername: collection.twitterUsername,
                    instagramUsername: collection.instagramUsername
                )
            )

        } catch {
            print("⚠️ APIOpenseaProvider: \(address) | \(error)")
            throw APIError.BadResponse
        }
    }
}
