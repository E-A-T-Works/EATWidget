//
//  Entry.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI
import WidgetKit


enum AssetWidgetEntryKind {
    case Placeholder
    case Unconfigured
    case NotFound
    case Unsupported
    case Success
}


struct RandomAssetWidgetEntry: TimelineEntry {
    let date: Date
    let kind: AssetWidgetEntryKind
    let displayInfo: Bool
    let data: Asset?
}

