//
//  CollectionSectionViewModel.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/15/22.
//

import Foundation
import Combine
import SwiftUI


@MainActor
final class CollectionSectionViewModel: ObservableObject {
    
    // MARK: - Properties
    
    let address: String
    
    @Published private(set) var collection: NFTCollection?
    @Published private(set) var nfts: [NFTObject] = []
    @Published private(set) var loading: Bool = false
    
    private let collectionStorage = NFTCollectionStorage.shared
    private let objectStorage = NFTObjectStorage.shared
    
    // MARK: - Initialization
    
    init(address: String) {
        self.address = address
        
        load()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        objectStorage.$list
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .map { $0.filter { $0.address == self.address } }
            .assign(to: &$nfts)
    }
    
    private func load() {}
    
    // MARK: - Public Methods
    
    // Ref: https://github.com/renaudjenny/SwiftUI-with-Size-Classes
    func determineColumns(vertical: UserInterfaceSizeClass?, horizontal: UserInterfaceSizeClass?) -> Int {
        if vertical == .regular && horizontal == .compact {
            // iPhone Portrait or iPad 1/3 split view for Multitasking for instance
            return 2
        } else if vertical == .compact && horizontal == .compact {
            // some "standard" iPhone Landscape (iPhone SE, X, XS, 7, 8, ...)
            return 3
        } else if vertical == .compact && horizontal == .regular {
            // some "bigger" iPhone Landscape (iPhone Xs Max, 6s Plus, 7 Plus, 8 Plus, ...)
            return 4
        } else if vertical == .regular && horizontal == .regular {
            // macOS or iPad without split view - no Multitasking
            return 4
        } else {
            return 2
        }
    }
    

}

