//
//  BasicAssetWidget.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import WidgetKit
import SwiftUI

struct BasicAssetWidgetProvider: IntentTimelineProvider {
    func placeholder(
        in context: Context
    ) -> BasicAssetWidgetEntry {
        return BasicAssetWidgetEntry(
            date: Date(),
            kind: AssetWidgetEntryKind.Placeholder,
            displayInfo: false,
            data: nil
        )
    }
    
    func getSnapshot(
        for configuration: BasicAssetOptionsIntent,
        in context: Context,
        completion: @escaping (BasicAssetWidgetEntry) -> Void
    ) {
        completion(
            BasicAssetWidgetEntry(
                date: Date(),
                kind: AssetWidgetEntryKind.Placeholder,
                displayInfo: false,
                data: nil
            )
        )
    }
    
    func getTimeline(
        for configuration: BasicAssetOptionsIntent,
        in context: Context,
        completion: @escaping (Timeline<BasicAssetWidgetEntry>) -> Void
    ) {
        // TODO:
        
        print("GET TIMELINE")
        
        
        let timeline = Timeline(
            entries: [
                BasicAssetWidgetEntry(
                    date: Date(),
                    kind: AssetWidgetEntryKind.Success,
                    displayInfo: false,
                    data: nil
                )
            ],
            policy: .never
        )
        completion(timeline)
    }
}


struct BasicAssetWidgetEntry: TimelineEntry {
    let date: Date
    let kind: AssetWidgetEntryKind
    let displayInfo: Bool
    let data: AssetData?
}


struct BasicAssetWidgetEntryView : View {
    var entry: BasicAssetWidgetProvider.Entry
    
    var body: some View {
        switch entry.kind {
        case .Placeholder:
            Text("Placeholder")
        case .NotFound:
            Text("Not Found")
        case .Unsupported:
            Text("Unsupported")
        case .Success:
            Text("WIDGET")
        }
    }
}


struct BasicAssetWidget: Widget {
    let kind: String = "BasicAssetWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: BasicAssetOptionsIntent.self,
            provider: BasicAssetWidgetProvider()
        ) { entry in
            BasicAssetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NFT")
        .description("Choose an NFT to display.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
    
}
