//
//  API.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation
import SwiftUI

enum APIError: Error {
    case InvalidUrl
    case BadResponse
    case Unsupported
}

enum OpenSeaAssetsResponse {
    case Success(assets: [Asset])
    case Failure
}

enum OpenSeaAssetResponse {
    case Success(asset: Asset)
    case Failure
}


enum OpenSeaImageResponse {
    case Success(image: UIImage)
    case Failure
}

typealias OpenSeaApiAssetResponse = Asset

struct OpenSeaApiAssetsResponse: Decodable {
    let assets: [Asset]
}

struct EtherscanAccountBalanceResponse: Decodable {
    let status: String
    let message: String
    let result: String
}

struct EtherscanAccountBalanceResultResponse: Decodable {
    let account: String
    let balance: String
}

struct EtherscanAccountMultiBalanceResponse: Decodable {
    let status: String
    let message: String
    let result: [EtherscanAccountBalanceResultResponse]
}
