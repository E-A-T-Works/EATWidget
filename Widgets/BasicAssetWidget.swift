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
        //
        //  Parse intent configuration
        //
        
        print("GET TIMELINE")
        
        let identifier = configuration.Asset?.identifier
        let contractAddress = identifier?.components(separatedBy: "/").first
        let tokenId = identifier?.components(separatedBy: "/").last
        
        let displayInfo = configuration.DisplayInfo?.boolValue ?? false
        
        print("Intent Values: \(identifier ?? "MISSING") \(contractAddress ?? "MISSING") \(tokenId ?? "MISSING") \(displayInfo)")
        
        if contractAddress == nil || tokenId == nil {
            
            let timeline = Timeline(
                entries: [
                    BasicAssetWidgetEntry(
                        date: Date(),
                        kind: AssetWidgetEntryKind.Unconfigured,
                        displayInfo: false,
                        data: nil
                    )
                ],
                policy: .never
            )
            completion(timeline)
            return
        }
        
        //
        //  Fetch relevent data
        //
        
        
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
        case .Unconfigured:
            Text("Configuration Required")
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
