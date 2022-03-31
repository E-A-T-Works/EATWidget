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
    
    func parse(item: API_NFT) async -> NFT? {
        let address = item.address

        switch address {
        case "0x57f1887a8bf19b14fc0df6fd9b2acc9af147ea85":
            return nil // ENS addresses

//        case "0x282bdd42f4eb70e7a9d9f40c8fea0825b7f68c5d":
//            return await normalizeCryptopunk(item: item)

        case "0xf9a423b86afbf8db41d7f24fa56848f56684e43f":
            return await normalizeEveryIcon(item: item)

        default:
            return await normalizeGeneric(for: item)
        }
    }
}



// MARK: - Generic

extension NFTAdapters {
    private func normalizeGeneric(for item: API_NFT) async -> NFT? {
            
        guard let imageUrl = item.imageUrl else { return nil }
        guard let imageData = try? Data(contentsOf: imageUrl) else { return nil }
        
        // enforce 10mb size limit
        if imageData.count > (10 * 1_000_000) { return nil }
        guard let image = UIImage(data: imageData) else { return nil }
        
        var simulationUrl: URL?
        if item.animationUrl != nil && (item.animationUrl!.absoluteString.contains("generator.artblocks.io") || ["gif"].contains(item.animationUrl!.pathExtension)) {
            simulationUrl = item.animationUrl
        }
        
        return NFT(
            id: item.id,
            address: item.address,
            tokenId: item.tokenId,
            title: item.title,
            text: item.text,
            image: image,
            simulationUrl: simulationUrl,
            animationUrl: item.animationUrl,
            twitterUrl: nil,
            discordUrl: nil,
            openseaUrl: URL(string: "https://opensea.io/assets/\(item.address)/\(item.tokenId)"),
            externalUrl: nil,
            metadataUrl: item.metadataUrl,
            attributes: item.attributes.map { Attribute(key: $0.key, value: $0.value) }
        )
    }
    
    private func normalizeAlchemyNFT(item: APIAlchemyNFT) async -> NFT? {
        do {
            
            guard
                let imageUrl = item.media.first?.gateway ?? item.media.first?.raw,
                let metadata = item.metadata
            else {
                return nil
            }
            
            let imageUrlPathExtension = imageUrl.pathExtension
            
            var imageData: Data?
            
            switch imageUrlPathExtension {
            case "gif":
                imageData = nil
            case "mp4":
                imageData = nil
            default:
                imageData = try Data(contentsOf: imageUrl)
            }
            
            guard imageData != nil else { return nil }
            

            // enforce 10mb size limit
            if imageData!.count > (10 * 1_000_000) { return nil }
            guard let image = UIImage(data: imageData!) else { return nil }
            
            let attributes: [Attribute] = metadata.attributes
                .filter { $0.traitType != nil && $0.value != nil }
                .map { Attribute(key: $0.traitType!, value: $0.value!) }
            
            return NFT(
                id: "\(item.contract.address)/\(item.id.tokenId)",
                address: item.contract.address,
                tokenId: item.id.tokenId,
                title: item.title,
                text: item.text,
                image: image,
                simulationUrl: ["gif"].contains(imageUrlPathExtension) ? imageUrl : nil,
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
            
            let attributes: [Attribute] = (metadata.attributes )
                .filter { $0.traitType != nil && $0.value != nil }
                .map { Attribute(key: $0.traitType!, value: $0.value!) }

            return NFT(
                id: "\(item.contract.address)/\(item.id.tokenId)",
                address: item.contract.address,
                tokenId: item.id.tokenId,
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

    private func normalizeEveryIcon(item: API_NFT) async -> NFT? {
        
        guard let base64EncodedMetadata = item.metadataUrl?.absoluteString.replacingOccurrences(of: "data:application/json;base64,", with: "") else { return nil }

        guard let decodedData = Data(base64Encoded: base64EncodedMetadata) else { return nil }
        
        guard let jsonData = try? JSONSerialization.jsonObject(with: decodedData, options : .allowFragments) as? Dictionary<String,Any> else { return nil }

        guard let jsonSVGString = jsonData["image"] as? String else { return nil }

        let svgString = jsonSVGString
            .replacingOccurrences(of: "data:image/svg+xml,", with: "")
            .replacingOccurrences(of: "<style>rect{width:16px;height:16px;stroke-width:1px;stroke:#c4c4c4}.b{fill:#000}.w{fill:#fff}</style>", with: "")
            .replacingOccurrences(of: "class='b'", with: "fill='#000000'")
            .replacingOccurrences(of: "class='w'", with: "fill='#ffffff'")
            .replacingOccurrences(of: "<rect", with: "<rect stroke='#c4c4c4' stroke-width='1' width='16' height='16'")


        let temporaryDirectoryURL = URL(
            fileURLWithPath: NSTemporaryDirectory(),
            isDirectory: true
        )
        let temporaryFilename = ProcessInfo().globallyUniqueString
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(temporaryFilename)

        let svgData: Data = svgString.data(using: .utf8)!
        try? svgData.write(
            to: temporaryFileURL,
            options: .atomic
        )

        let frame = CGRect(x: 0, y: 0, width: 512, height: 512)

        let svgLayer = SVGLayer(contentsOf: temporaryFileURL)
        svgLayer.frame = frame

        guard let image = snapshotImage(for: svgLayer) else { return nil }

        try? FileManager.default.removeItem(at: temporaryFileURL)

        return NFT(
            id: item.id,
            address: item.address,
            tokenId: item.tokenId,
            title: item.title,
            text: item.text,
            image: image,
            simulationUrl: item.animationUrl,
            animationUrl: nil,
            twitterUrl: nil,
            discordUrl: nil,
            openseaUrl: URL(string: "https://opensea.io/assets/\(item.address)/\(item.tokenId)"),
            externalUrl: nil,
            metadataUrl: item.metadataUrl,
            attributes: item.attributes.map { Attribute(key: $0.key, value: $0.value) }
        )
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
