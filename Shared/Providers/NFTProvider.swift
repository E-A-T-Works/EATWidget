//
//  NFTProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import Foundation
import Combine


//enum NFTProviderState: String {
//    case pending, fetching, processing
//}
//
//enum NFTProviderDataState: String {
//    case pending, success, failure
//}
//
//struct NFTProviderData: Identifiable {
//    let id: String
//    var state: NFTProviderDataState
//    var raw: APIAlchemyNFT
//    var parsed: NFT?
//}

//
//final class NFTProvider: ObservableObject {
//    @Published private(set) var state: NFTProviderState = .pending
//    @Published private(set) var data: [String: NFTProviderData] = [:]
//
//    let ownerAddress: String
//
//    private let adapters: NFTAdapters = NFTAdapters.shared
//    private let apiProvider: APIAlchemyProvider = APIAlchemyProvider.shared
//
//    private var disposables = Set<AnyCancellable>()
//
//
//    init(ownerAddress: String) {
//        self.ownerAddress = ownerAddress
//    }
//
//    func fetchAndProcess() async {
//        state = .fetching
//        await fetch()
//
//        state = .processing
//        await process()
//
//        state = .pending
//    }
//
//
//    private func fetch() async {
//
//        var results: [APIAlchemyNFT] = [APIAlchemyNFT]()
//        
//        do {
//            results = try await apiProvider.getNFTs(for: ownerAddress)
//        } catch {
//            print("⚠️ \(error)")
//        }
//
//        data = results.reduce([:], { partialResult, item in
//            let address = item.contract.address
//            let tokenId = item.id.tokenId
//            let key = "\(address)/\(tokenId)"
//
//            var updated = partialResult
//            updated[key] = NFTProviderData(id: key, state: .pending, raw: item, cleaned: nil)
//
//            return updated
//        })
//    }
//
//    private func process() async {
//
////        sleep(5)
//
//    }
//
//
//
////    func fetchNFTs(
////        ownerAddress: String,
////        strategy: DataStrategies = .Alchemy
////    ) async throws -> [DataFetchResultKey: [NFT]] {
////
////        var results: [DataFetchResultKey: [NFT]] = [
////            .Supported: [NFT](),
////            .Unsupported: [NFT]()
////        ]
////
////        switch strategy {
////        case .Alchemy:
////            let response = try! await apiAlchemyProvider.fetchNFTs(ownerAddress: ownerAddress)
////
////            results = await adapters.mapAlchemyDataToNFTs(list: response)
////        }
////
////        return results
////    }
//}
