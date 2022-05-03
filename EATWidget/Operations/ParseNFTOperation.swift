//
//  ParseNFTOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation

final class ParseNFTOperation: AsyncOperation {
    var parsed: NFT?
    
    private let data: API_NFT
    private let completionHandler: ((NFT?) -> Void)?
    
    private let adapters: NFTAdapters = NFTAdapters.shared
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    init(data: API_NFT, completionHandler: ((NFT?) -> Void)? = nil) {
        self.data = data
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {
            let address = data.address
            let tokenId = data.tokenId
            
            parsed = await adapters.parse(item: data)
                        
            await fb.logNFT(address: address, tokenId: tokenId, success: parsed != nil)
            
            if completionHandler != nil { completionHandler!(parsed) }
            
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
    }
}
