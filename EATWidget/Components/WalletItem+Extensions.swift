//
//  WalletItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import Foundation

extension WalletItem {
    init(item: CachedWallet) {
        address = item.address ?? ""
        title = item.title ?? ""
    }
}
