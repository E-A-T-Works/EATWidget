//
//  Entry.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit


// MARK: Structs

struct AssetData {
    let contractAddress: String?
    let tokenId: String?
    
    let image: UIImage?
    
    let backgroundColor: Color?
    let title: String?
}

// MARK: Enums

enum AssetWidgetEntryKind {
    case Placeholder
    case Unconfigured
    case NotFound
    case Unsupported
    case Success
}


// MARK: Widget Entries



struct RandomAssetWidgetEntry: TimelineEntry {
    let date: Date
    let kind: AssetWidgetEntryKind
    let displayInfo: Bool
    let data: AssetData?
}

