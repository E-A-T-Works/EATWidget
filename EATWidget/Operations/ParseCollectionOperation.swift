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
    
    init(address: String, completionHandler: ((Collection?) -> Void)? = nil) {
        self.address = address
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func main() {
        Task {
            
            let api: APIOpenseaProvider = APIOpenseaProvider()
            
            print("❇️ parse collection: \(address)")
            
            var contract: APIContract?
            do {
                contract = try await api.getContract(for: address)
            } catch {
                print("⚠️ failed to lookup contract: \(error)")
                parsed = nil
                state = .finished
                return
            }
            
            print("❇️ got contract: \(contract)")
            
            guard let collection: APICollection = contract?.collection else {
                parsed = nil
                state = .finished
                return
            }

            parsed = await adapters.parse(item: collection)
            
            // mark task as done
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        // Do any other cleanup
    }
}
