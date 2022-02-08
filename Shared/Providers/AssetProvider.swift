//
//  AssetProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import SwiftUI


final class AssetProvider {
    
    static func fetchAssets(ownerAddress: String) async throws -> [Asset] {
        do {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "rinkeby-api.opensea.io"
            components.path = "/api/v1/assets"
            components.queryItems = [
                URLQueryItem(name: "owner", value: ownerAddress),
                URLQueryItem(name: "offset", value: "0"),
                URLQueryItem(name: "limit", value: "25"),
                URLQueryItem(name: "order_direction", value: "desc")
           ]
            
            guard let url = components.url else {
                throw OpenSeaError.InvalidUrl
            }
            
            let request = APIRequest(url: url)
            
            let response = try await request.perform(ofType: OpenSeaApiAssetsResponse.self)
            return response.assets
        } catch {
            print("⚠️ NFTProvider::fetchNFTs: \(error.localizedDescription)")
            
            throw OpenSeaError.BadResponse
        }
        
    }
    
    
    static func fetchAsset(contractAddress: String, tokenId:String) async throws -> Asset {
        print("fetchNFTs \(contractAddress) \(tokenId)")
        
        do {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "rinkeby-api.opensea.io"
            components.path = "/api/v1/asset/\(contractAddress)/\(tokenId)"
            
            guard let url = components.url else {
                
                print("INVALID URL")
                
                throw OpenSeaError.InvalidUrl
            }
            
            let request = APIRequest(url: url)
            return try await request.perform(ofType: OpenSeaApiAssetResponse.self)
            
        } catch {
            print("⚠️ NFTProvider::fetchNFT: \(error.localizedDescription)")
            
            throw OpenSeaError.BadResponse
        }
    }
    
    static func fetchAssetImage(contractAddress: String, tokenId: String) async throws -> UIImage {
        do {
            let item = try await self.fetchAsset(contractAddress: contractAddress, tokenId: tokenId)
            let imageUrl = item.imageUrl
            
            if imageUrl == nil {
                throw OpenSeaError.Unsupported
            }
            
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
            let (data, _) = try await session.data(from: imageUrl!)
            
            return UIImage(data: data)!
        } catch {
            print("⚠️ NFTProvider::fetchNFTImage: \(error.localizedDescription)")
            
            throw OpenSeaError.BadResponse
        }
    }
    
    static func fetchRandomAsset(ownerAddress: String) async throws -> Asset {
        do {
            let items = try await fetchAssets(ownerAddress: ownerAddress)
            
            let randomIndex = Int.random(in: 0..<items.count)
            
            return items[randomIndex]
        
        } catch {
            print("⚠️ NFTProvider::fetchRandomNFT: \(error.localizedDescription)")
            
            throw OpenSeaError.BadResponse
        }
    }
}
