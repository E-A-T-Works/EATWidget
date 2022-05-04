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
                    
                    collection: raw.collection != nil ? APICollection(
                        id: raw.contract.address,
                        
                        address: raw.contract.address,
                        
                        title: raw.collection!.title,
                        text: raw.collection!.text,
                        
                        thumbnailUrl: raw.collection!.thumbnailUrl,
                        bannerUrl: raw.collection!.bannerUrl,
                                                
                        twitterUrl: raw.collection!.twitterUsername != nil ? URL(string:"https://twitter.com/\(raw.collection!.twitterUsername!)") : nil,
                        instagramUrl: raw.collection!.instagramUsername != nil ? URL(string:"https://instagram.com/\(raw.collection!.instagramUsername!)") : nil,
                        wikiUrl: raw.collection!.wikiUrl,
                        discordUrl: raw.collection!.discordUrl,
                        chatUrl: raw.collection!.chatUrl,
                        openseaUrl: raw.collection!.openseaUrl,
                        externalUrl: raw.collection!.externalUrl
                    ) : nil,
                    
                    title: raw.title,
                    text: raw.text,
                    
                    imageUrl: raw.imageUrl,
                    animationUrl: raw.animationUrl,
                    
                    openseaUrl: raw.permalink,
                    externalUrl: raw.permalink,
                    metadataUrl: raw.metadataUrl,
                    
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
                    
                    twitterUrl: collection.twitterUsername != nil ? URL(string:"https://twitter.com/\(collection.twitterUsername!)") : nil,
                    instagramUrl: collection.instagramUsername != nil ? URL(string:"https://instagram.com/\(collection.instagramUsername!)") : nil,
                    wikiUrl: collection.wikiUrl,
                    discordUrl: collection.discordUrl,
                    chatUrl: collection.chatUrl,
                    openseaUrl: collection.openseaUrl,
                    externalUrl: collection.externalUrl
                )
            )

        } catch {
            print("⚠️ APIOpenseaProvider: \(address) | \(error)")
            throw APIError.BadResponse
        }
    }
}
