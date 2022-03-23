//
//  NFTItem+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

extension NFTParseTaskItem {
    init(item: NFTParseTask) {
        self.address = item.address
        self.tokenId = item.tokenId
        self.state = item.state
        
        switch item.state {
        case .success:
            self.title = item.parsed?.title
            self.image = item.parsed?.image
            
        case .failure:
            self.title = item.raw.title

        case .pending:
            self.title = item.raw.title
        }
    }
}
