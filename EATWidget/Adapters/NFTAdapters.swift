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
            
//        case "0x976a145bce31266d3ed460a359330dd53466db97":
//            return await normalizeTheKiss(item: item)
//            
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
        } else if ["svg"].contains(item.imageUrl!.pathExtension) {
            simulationUrl = item.imageUrl
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


// MARK: - The Kiss

extension NFTAdapters {

    private func normalizeTheKiss(item: API_NFT) async -> NFT? {

        print("normalizeTheKiss")
//        guard let imageUrl = item.imageUrl else { return nil }
        
        let svgString = "<svg xmlns='http://www.w3.org/2000/svg' width='1000' height='1000' viewBox='0 0 32000 32000'><filter id='t' x='0%' y='0%' width='100%' height='100%'><feTurbulence type='fractalNoise' baseFrequency='0.04' result='n' numOctaves='5' /><feDiffuseLighting in='n' lighting-color='white' surfaceScale='0.4' diffuseConstant='1.35' result='l'><feDistantLight azimuth='-90' elevation='45' /></feDiffuseLighting><feBlend in='SourceGraphic' in2='l' mode='multiply'/></filter><style>circle{stroke:#fbf8f4;stroke-width:4;stroke-opacity:100%}.c0{fill:#1b998b}.c1{fill:#1b998b}.c2{fill:#1b998b}.c3{fill:#1b998b}.c4{fill:#302840}.c5{fill:#302840}.c6{fill:#302840}.c7{fill:#d4e2d4}.c8{fill:#d4e2d4}.c9{fill:#d4e2d4}.c10{fill:#ffb433}.c11{fill:#ffb433}.c12{fill:#da6746}.c13{fill:#da6746}.c14{fill:#da6746}.c15{fill:#da6746}.m0{fill:#d4e2d4}.m1{fill:#d4e2d4}.m2{fill:#d4e2d4}.m3{fill:#d4e2d4}.m4{fill:#ffb433}.m5{fill:#ffb433}.m6{fill:#ffb433}.m7{fill:#ffb433}</style><g filter='url(#t)'><rect width='32000' height='32000' fill='#fbf8f4'/><g transform='rotate(0,16000,16000)'><circle cx='16000' cy='16000' r='12800' class='c14'/><circle cx='16000' cy='9604' r='6404' class='m2'/><circle cx='16000' cy='22404' r='6395' class='m2'/><circle cx='24533' cy='16010' r='4266' class='c6'/><circle cx='19413' cy='16008' r='853' class='c0'/><circle cx='16000' cy='7174' r='3974' class='c3'/><circle cx='16000' cy='13578' r='2429' class='c2'/><circle cx='19943' cy='11625' r='1971' class='c3'/><circle cx='17602' cy='11246' r='400' class='c13'/><circle cx='16000' cy='6573' r='3373' class='c14'/><circle cx='16000' cy='10548' r='601' class='c3'/><circle cx='17171' cy='10355' r='585' class='c10'/><circle cx='16527' cy='10038' r='131' class='c0'/><circle cx='16000' cy='4632' r='1432' class='c5'/><circle cx='16000' cy='8006' r='1940' class='c5'/><circle cx='18181' cy='5901' r='1090' class='c14'/><circle cx='16877' cy='6032' r='219' class='c12'/><circle cx='7466' cy='16010' r='4266' class='c6'/><circle cx='12586' cy='16008' r='853' class='c0'/><circle cx='12056' cy='11625' r='1971' class='c3'/><circle cx='14397' cy='11246' r='400' class='c13'/><circle cx='14828' cy='10355' r='585' class='c10'/><circle cx='15472' cy='10038' r='131' class='c0'/><circle cx='13818' cy='5901' r='1090' class='c14'/><circle cx='15122' cy='6032' r='219' class='c12'/></g></g></svg>"

//        let frame = CGRect(x: 0, y: 0, width: 512, height: 512)
//
//        let svgLayer = SVGLayer(contentsOf: imageUrl)
//        svgLayer.frame = frame
//
//        guard let image = snapshotImage(for: svgLayer) else { return nil }
        
        print("✅ \(svgString)")
        
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
        
        print("➡️ \(svgData)")

        let frame = CGRect(x: 0, y: 0, width: 512, height: 512)

        let svgLayer = SVGLayer(contentsOf: temporaryFileURL)
        svgLayer.frame = frame

        guard let image = snapshotImage(for: svgLayer) else {
            print("💥 FAILED")
            return nil }
        
        try? FileManager.default.removeItem(at: temporaryFileURL)


        return NFT(
            id: item.id,
            address: item.address,
            tokenId: item.tokenId,
            title: item.title,
            text: item.text,
            image: image,
            simulationUrl: nil,
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
