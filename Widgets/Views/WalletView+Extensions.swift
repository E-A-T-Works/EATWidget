//
//  WalletView+Extensions.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

extension WalletView {
    init(item: Wallet) {
        address = item.address!
        title = item.title
    }
}
