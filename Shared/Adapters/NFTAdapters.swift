//
//  NFTAdapters.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation


final class NFTAdapters {
    
    static func mapMetadata(address: String, data: APIAlchemyMetadata) -> APIAlchemyMetadata {
        
        switch address {
        case "0xf9a423b86afbf8db41d7f24fa56848f56684e43f":
            return mapEveryIconMetaData(data: data)
        default:
            return data
        }
    }
    
    static func mapEveryIconMetaData(data: APIAlchemyMetadata) -> APIAlchemyMetadata {
        return data
    }
    
}
