//
//  ParseNFTOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation

final class ParseNFTOperation: AsyncOperation {
    var parsed: NFT?
    
    private let data: APIAlchemyNFT
    private let completionHandler: ((NFT?) -> Void)?
    
    private let adapters: NFTAdapters = NFTAdapters.shared
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    init(data: APIAlchemyNFT, completionHandler: ((NFT?) -> Void)? = nil) {
        self.data = data
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {
            
            let address = data.contract.address
            let tokenId = data.id.tokenId
            
            parsed = await adapters.parse(item: data)
            
            // Sync Results
            await fb.logNFT(address: address, tokenId: tokenId, success: parsed != nil)
            
            // mark task as done
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}
