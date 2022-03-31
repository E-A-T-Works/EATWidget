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
    case Instagram
    case Discord
    case Chat
    case Wiki
    case Other
}

struct ExternalLink: Hashable {
    let target: ExternalLinkTarget
    let url: URL
}
