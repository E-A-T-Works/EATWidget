//
//  Wallet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation

struct Wallet: Identifiable, Hashable {
    let id: String
    let address: String
    let title: String?
}
