//
//  ParseCollectionOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import Foundation

final class ParseCollectionOperation: AsyncOperation {
    var parsed: Collection?
    
    private let address: String
    private let completionHandler: ((Collection?) -> Void)?
    
    private let adapters: CollectionAdapters = CollectionAdapters.shared
    private let fb: FirebaseProvider = FirebaseProvider.shared
    
    init(address: String, completionHandler: ((Collection?) -> Void)? = nil) {
        self.address = address
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {

            parsed = await adapters.parse(address: address)
            
            // mark task as done
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}
