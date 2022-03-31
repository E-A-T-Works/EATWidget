//
//  NFTAdapters.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI
import PocketSVG



final class NFTAdapters {
    
    static let shared: NFTAdapters = NFTAdapters()
    
    private init() {}
    
    func parse(item: APIAlchemyNFT) async -> NFT? {
        let address = item.contract.address

        switch address {
        case "0x282bdd42f4eb70e7a9d9f40c8fea0825b7f68c5d":
            return await normalizeCryptopunk(item: item)

        case "0xf9a423b86afbf8db41d7f24fa56848f56684e43f":
            return await normalizeEveryIcon(item: item)
            
//        case "0xa7d8d9ef8d8ce8992df33d8b8cf4aebabd5bd270":
//            return await normalizeArtblocks(item: item)
            
//        case "0x1ca15ccdd91b55cd617a48dc9eefb98cae224757":
//            return await normalizeStrangeAttractors(item: item)
            
        default:
            return await normalizeAlchemyNFT(item: item)
        }
    }
}



// MARK: - Generic

extension NFTAdapters {
    private func normalizeAlchemyNFT(item: APIAlchemyNFT) async -> NFT? {
        do {
            
            guard
                let imageUrl = item.media.first?.gateway ?? item.media.first?.raw,
                let metadata = item.metadata
            else {
                return nil
            }

            let imageData = try Data(contentsOf: imageUrl)
            
            // enforce 10mb size limit
            if imageData.count > (10 * 1_000_000) { return nil }
            guard let image = UIImage(data: imageData) else { return nil }
            
            let attributes: [Attribute] = (metadata.attributes ?? [APIAlchemyAttribute]())
                .filter { $0.traitType != nil && $0.value != nil }
                .map { Attribute(key: $0.traitType!, value: $0.value!) }
            
            return NFT(
                id: "\(item.contract.address)/\(item.id.tokenId)",
                address: item.contract.address,
                tokenId: item.id.tokenId,
                standard: item.id.tokenMetadata.tokenType,
                title: item.title,
                text: item.text,
                image: image,
                simulationUrl: nil,
                animationUrl: item.metadata?.animationUrl,
                twitterUrl: nil,
                discordUrl: nil,
                openseaUrl: URL(string: "https://opensea.io/assets/\(item.contract.address)/\(item.id.tokenId)"),
                externalUrl: nil,
                metadataUrl: item.tokenUri.gateway ?? item.tokenUri.raw,
                attributes: attributes
            )
        } catch {
            print("⚠️ normalizeAlchemyNFT \(item.contract.address) \(item.id.tokenId) \(error)")
            return nil
        }
    }

}



// MARK: - Cryptopunks

extension NFTAdapters {
    private func normalizeCryptopunk(item: APIAlchemyNFT) async -> NFT? {

        do {
            guard
                let imageUrl = item.media.first?.gateway ?? item.media.first?.raw,
                let metadata = item.metadata
            else {
                return nil
            }
            
            let imageData = try Data(contentsOf: imageUrl)
            
            // enforce 10mb size limit
            if imageData.count > (10 * 1_000_000) { return nil }
            
            guard let image = UIImage(data: imageData) else { return nil }
            
            let attributes: [Attribute] = (metadata.attributes ?? [APIAlchemyAttribute]())
                .filter { $0.traitType != nil && $0.value != nil }
                .map { Attribute(key: $0.traitType!, value: $0.value!) }

            return NFT(
                id: "\(item.contract.address)/\(item.id.tokenId)",
                address: item.contract.address,
                tokenId: item.id.tokenId,
                standard: item.id.tokenMetadata.tokenType,
                title: item.title,
                text: item.text,
                image: image,
                simulationUrl: nil,
                animationUrl: item.metadata?.animationUrl,
                twitterUrl: URL(string: "https://twitter.com/v1punks"),
                discordUrl: URL(string: "https://discord.com/invite/v1punks"),
                openseaUrl: nil,
                externalUrl: URL(string: "https://www.v1punks.io"),
                metadataUrl: item.tokenUri.gateway ?? item.tokenUri.raw,
                attributes: attributes
            )
        } catch {
            print("⚠️ normalizeCryptopunk \(item.contract.address) \(item.id.tokenId) \(error)")
            return nil
        }
    }
    
}



// MARK: - EveryIcon

extension NFTAdapters {

    ///
    /// EveryIcon has the entire SVG written in the image field
    /// image: data:image/svg+xml,<svg width='512' height='512'>...</svg>
    ///
    /// We need to parse it, write it to a temporary file so we can read it and use PocketSVG
    /// to convert it to a UIImage and save it to a temporary
    ///
    ///
    private func normalizeEveryIcon(item: APIAlchemyNFT) async -> NFT? {
        do {
           
            guard let metadata = item.metadata else { return nil }
            
            guard let svgString = metadata.image?
                    .replacingOccurrences(of: "data:image/svg+xml,", with: "")
                    .replacingOccurrences(of: "<style>rect{width:16px;height:16px;stroke-width:1px;stroke:#c4c4c4}.b{fill:#000}.w{fill:#fff}</style>", with: "")
                    .replacingOccurrences(of: "class='b'", with: "fill='#000000'")
                    .replacingOccurrences(of: "class='w'", with: "fill='#ffffff'")
                    .replacingOccurrences(of: "<rect", with: "<rect stroke='#c4c4c4' stroke-width='1' width='16' height='16'") else { return nil }
            
            let temporaryDirectoryURL = URL(
                fileURLWithPath: NSTemporaryDirectory(),
                isDirectory: true
            )
            
            let temporaryFilename = ProcessInfo().globallyUniqueString

            let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(temporaryFilename)
            
            let svgData: Data = svgString.data(using: .utf8)!
            try svgData.write(
                to: temporaryFileURL,
                options: .atomic
            )
            
            
            let frame = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            let svgLayer = SVGLayer(contentsOf: temporaryFileURL)
            svgLayer.frame = frame

            guard let image = snapshotImage(for: svgLayer) else { return nil }

            try FileManager.default.removeItem(at: temporaryFileURL)
            
            return NFT(
                id: "\(item.contract.address)/\(item.id.tokenId)",
                address: item.contract.address,
                tokenId: item.id.tokenId,
                standard: item.id.tokenMetadata.tokenType,
                title: item.title,
                text: item.text,
                
                image: image,
                simulationUrl: item.metadata?.animationUrl,
                animationUrl: nil,
                
                twitterUrl: URL(string: "https://twitter.com/eatworksnyc"),
                discordUrl: URL(string: "https://discord.gg/TAjvAMVUmc"),
                openseaUrl: URL(string: "https://opensea.io/assets/\(item.contract.address)/\(item.id.tokenId)"),
                externalUrl: URL(string: "https://www.eatworks.xyz/projects-3/e-a-t-works-every-icon"),
                metadataUrl: nil,

                attributes: [Attribute]()
            )
        } catch {
            print("⚠️ normalizeEveryIcon \(item.contract.address) \(item.id.tokenId) \(error)")
            return nil
        }
    }
    
}



// MARK: - Strange Attractions

extension NFTAdapters {
    private func normalizeStrangeAttractors(item: APIAlchemyNFT) async -> NFT? {
        // TODO: Implement this
        return nil
    }
}



// MARK: - ArtBlocks

extension NFTAdapters {
    private func normalizeArtblocks(item: APIAlchemyNFT) async -> NFT? {

        do {
            guard
                let imageUrl = item.media.first?.gateway ?? item.media.first?.raw,
                let metadata = item.metadata
            else {
                return nil
            }
            
            let imageData = try Data(contentsOf: imageUrl)
            
            // enforce 10mb size limit
            if imageData.count > (10 * 1_000_000) { return nil }
            
            guard let image = UIImage(data: imageData) else { return nil }
            
            let attributes: [Attribute] = (metadata.attributes ?? [APIAlchemyAttribute]())
                .filter { $0.traitType != nil && $0.value != nil }
                .map { Attribute(key: $0.traitType!, value: $0.value!) }

            return NFT(
                id: "\(item.contract.address)/\(item.id.tokenId)",
                address: item.contract.address,
                tokenId: item.id.tokenId,
                standard: item.id.tokenMetadata.tokenType,
                title: item.title,
                text: item.text,
                image: image,
                simulationUrl: item.metadata?.animationUrl,
                animationUrl: nil,
                twitterUrl: nil,
                discordUrl: nil,
                openseaUrl: URL(string: "https://opensea.io/assets/\(item.contract.address)/\(item.id.tokenId)"),
                externalUrl: nil,
                metadataUrl: item.tokenUri.gateway ?? item.tokenUri.raw,
                attributes: attributes
            )
        } catch {
            print("⚠️ normalizeUnknownSignals \(item.contract.address) \(item.id.tokenId) \(error)")
            return nil
        }
    }
}



// MARK: - Helpers

extension NFTAdapters {
    
    private func snapshotImage(for layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
