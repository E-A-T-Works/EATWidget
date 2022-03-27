//
//  Helpers.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/27/22.
//

import Foundation


enum ExternalLinkTarget {
    case Opensea
    case Etherscan
    case Twitter
    case Discord
    case Other
}

struct ExternalLink: Hashable {
    let target: ExternalLinkTarget
    let url: URL
}
