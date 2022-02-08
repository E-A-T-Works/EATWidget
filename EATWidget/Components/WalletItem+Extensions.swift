//
//  Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation

extension WalletItem {
    init(item: Wallet) {
        address = item.address!
        title = item.title
    }
}
