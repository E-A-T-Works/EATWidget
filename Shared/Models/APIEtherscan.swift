//
//  APIEtherscan.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/14/22.
//

import Foundation

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
