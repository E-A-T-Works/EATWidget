//
//  ParseNFTOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation
import Firebase

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
            
            let address = data.contract.address
            let tokenId = data.id.tokenId
            
            parsed = await adapters.parse(item: data)
            
            do {
                let db = Firestore.firestore()
                
                try await db
                    .collection("contracts")
                    .document(address)
                    .collection("assets")
                    .document(tokenId)
                    .setData([
                        "success": parsed != nil
                    ])
            } catch {
                print("⚠️ Failed to log to firestore \(error)")
            }
            
            // mark task as done
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}
