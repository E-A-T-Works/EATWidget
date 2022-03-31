//
//  ParseCollectionOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/28/22.
//

import Foundation

final class ParseCollectionOperation: AsyncOperation {
    var parsed: Collection?
    
    private let data: APICollection
    private let completionHandler: ((Collection?) -> Void)?
     
    private let adapters: CollectionAdapters = CollectionAdapters.shared
    
    init(data: APICollection, completionHandler: ((Collection?) -> Void)? = nil) {
        self.data = data
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {
            parsed = await adapters.parse(item: data)
            
            // mark task as done
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}
