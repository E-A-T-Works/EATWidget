//
//  NFTAdapters.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI
import FirebaseStorage
import FirebaseFunctions


final class NFTAdapters {
    
    static let shared: NFTAdapters = NFTAdapters()
    
    private init() {}
    
    func parse(item: API_NFT) async -> NFT? {
        let address = item.address

        switch address {
        //
        // ENS addresses
        case "0x57f1887a8bf19b14fc0df6fd9b2acc9af147ea85":
            return nil

        default:
            return await normalize(for: item)
        }
    }
    
    
    private func normalize(for item: API_NFT) async -> NFT? {
        
        guard let imageUrl = item.imageUrl else { return nil }

        var image: UIImage?
        if imageUrl.pathExtension.lowercased() == "svg" {
            
            guard let svgImageData = resolveImageData(item: item) else { return nil }
            if svgImageData.count > (10 * 1_000_000) { return nil }

            let storage = Storage.storage()

            let baseFilePath = "svg2png/\(item.address)"
            let baseFileName = "\(item.tokenId)"
            
            let newMetadata = StorageMetadata()
            newMetadata.contentType = "image/svg+xml"
                        
            let svgRef = storage.reference().child(baseFilePath).child("\(baseFileName).svg");
            svgRef.putData(svgImageData, metadata: newMetadata)

            
            lazy var functions = Functions.functions()
            let callable = functions.httpsCallable("convertSvgToPngFn")
            
            guard let result = try? await callable.call(["address": item.address, "tokenId": item.tokenId]) else { return nil }
            
            guard let resultData = result.data as? [String: Any] else { return nil }
            guard let pngUrlRaw = resultData["url"] as? String else { return nil }
            
            guard let pngUrl = URL(string: pngUrlRaw) else { return nil }
            
            guard let pngImageData = try? Data(contentsOf: pngUrl) else { return nil }
            image = UIImage(data: pngImageData)
            
        } else {
            guard let imageData = resolveImageData(item: item) else { return nil }
            // enforce 10mb size limit
            if imageData.count > (10 * 1_000_000) { return nil }
            image = UIImage(data: imageData)
        }
        
        if image == nil { return nil }
        
        var animationUrl: URL?
        if item.animationUrl != nil && item.animationUrl!.pathExtension != "" && !["gif"].contains(item.animationUrl!.pathExtension) {
            animationUrl = item.animationUrl
        }
        
        var simulationUrl: URL?
        if item.animationUrl != nil && (item.animationUrl!.pathExtension == "" || ["gif"].contains(item.animationUrl!.pathExtension)) {
            simulationUrl = item.animationUrl
        }
        
        return NFT(
            id: item.id,
            
            address: item.address,
            tokenId: item.tokenId,
            
            title: item.title,
            text: item.text,
            
            image: image!,
            animationUrl: animationUrl,
            simulationUrl: simulationUrl,
            
            openseaUrl: item.openseaUrl,
            
            externalUrl: item.externalUrl,
            metadataUrl: item.metadataUrl,
            
            attributes: item.attributes.map { Attribute(key: $0.key, value: $0.value) }
        )
    }
}


// MARK: - Helpers

extension NFTAdapters {
    private func resolveImageData(item: API_NFT) -> Data? {
        let address = item.address

        switch address {
        //
        // ENS addresses
        case "0x57f1887a8bf19b14fc0df6fd9b2acc9af147ea85":
            return nil

        //
        // everyicon
        case "0xf9a423b86afbf8db41d7f24fa56848f56684e43f":
            guard let svgString = resolveSVGString(item: item) else { return nil }
            let svgData: Data = svgString.data(using: .utf8)!

            return svgData
            
        //
        // glitchy bitches
        case "0x7de6581ed7d3113000bfa930a6815cbcf0945019":
            guard let metadataUrl = item.metadataUrl else { return nil }
            guard let jsonMetadata = try? Data(contentsOf: metadataUrl) else { return nil }
            guard let jsonData = try? JSONSerialization.jsonObject(with: jsonMetadata, options : .allowFragments) as? Dictionary<String, Any> else { return nil }

            guard let revealedImages = (jsonData["collapsed"] as? Dictionary<String, Any>)?["revealed_images"] as? [String] else { return nil }

            guard let imageUrl = URL(string: revealedImages.last ?? "") else { return nil }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return nil }
            
            return imageData
            
        default:
            
            guard let imageUrl = item.imageUrl else { return nil }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return nil }
            
            return imageData
        }
    }
    
    
    private func resolveSVGString(item: API_NFT) -> String? {
        let address = item.address
        
        guard let imageUrl = item.imageUrl else { return nil }
        if imageUrl.pathExtension.lowercased() != "svg" { return nil }

        switch address {
        //
        // everyicon
        case "0xf9a423b86afbf8db41d7f24fa56848f56684e43f":
            guard let metadataUrl = item.metadataUrl else { return nil }
            let base64EncodedMetadata = metadataUrl.absoluteString.replacingOccurrences(of: "data:application/json;base64,", with: "")
            guard let decodedData = Data(base64Encoded: base64EncodedMetadata) else { return nil }
            guard let jsonData = try? JSONSerialization.jsonObject(with: decodedData, options : .allowFragments) as? Dictionary<String,Any> else { return nil }
            
            guard let jsonSVGString = jsonData["image"] as? String else { return nil }
            
            let svgString = jsonSVGString
                .replacingOccurrences(of: "data:image/svg+xml,", with: "")
                .replacingOccurrences(of: "<svg width='512' height='512'", with: "<svg viewBox='0 0 512 512' width='512' height='512'")
                .replacingOccurrences(of: "<style>rect{width:16px;height:16px;stroke-width:1px;stroke:#c4c4c4}.b{fill:#000}.w{fill:#fff}</style>", with: "")
                .replacingOccurrences(of: "class='b'", with: "fill='#000000'")
                .replacingOccurrences(of: "class='w'", with: "fill='#ffffff'")
                .replacingOccurrences(of: "<rect", with: "<rect stroke='#c4c4c4' stroke-width='1' width='16' height='16'")
            
            return svgString
          
        default:
            let svgString = try? String(contentsOf: item.imageUrl!)

            return svgString
        }
    }
    
    
    
    private func snapshotImage(for layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
