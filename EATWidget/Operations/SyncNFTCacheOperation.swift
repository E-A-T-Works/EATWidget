//
//  SyncNFTCacheOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation


final class SyncNFTCacheOperation: AsyncOperation {
    
    private let list: [NFT]
    private let completionHandler: (() -> Void)?
    
    private let storage = NFTObjectStorage.shared
    
    init(list: [NFT], completionHandler: (() -> Void)? = nil) {
        self.list = list
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        
        state = .finished
    }
    
}
