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
    private var task: URLSessionDataTask?
    
    private let adapters: NFTAdapters = NFTAdapters.shared
    
    init(data: APIAlchemyNFT, completionHandler: ((NFT?) -> Void)? = nil) {
        self.data = data
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {
            parsed = await adapters.parse(item: data)
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}
