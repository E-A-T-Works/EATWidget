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
            kind: .Placeholder,
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
                kind: .Placeholder,
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
        
        let identifier = configuration.Asset?.identifier
        let contractAddress = identifier?.components(separatedBy: "/").first
        let tokenId = identifier?.components(separatedBy: "/").last
        
        let displayInfo = configuration.DisplayInfo?.boolValue ?? false
        
        if contractAddress == nil || tokenId == nil {
            
            let timeline = Timeline(
                entries: [
                    BasicAssetWidgetEntry(
                        date: Date(),
                        kind: .Unconfigured,
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
        
        Task {
            do {
                let asset = try await AssetProvider.fetchAsset(contractAddress: contractAddress!, tokenId: tokenId!)
                
                let timeline = Timeline(
                    entries: [
                        BasicAssetWidgetEntry(
                            date: Date(),
                            kind: .Success,
                            displayInfo: displayInfo,
                            data: asset
                        )
                    ],
                    policy: .never
                )
                completion(timeline)
                return
                
            } catch {
                print("⚠️ BasicAssetWidget::getTimeline: \(error)")
                
                let timeline = Timeline(
                    entries: [
                        BasicAssetWidgetEntry(
                            date: Date(),
                            kind: .NotFound,
                            displayInfo: false,
                            data: nil
                        )
                    ],
                    policy: .never
                )
                completion(timeline)
                return
            }
            
        }
    }
}


struct BasicAssetWidgetEntry: TimelineEntry {
    let date: Date
    let kind: WidgetEntryKind
    let displayInfo: Bool
    let data: Asset?
}


struct BasicAssetWidgetEntryView : View {
    var entry: BasicAssetWidgetProvider.Entry
    
    var body: some View {
        switch entry.kind {
        case .Placeholder:
            PlaceholderView()
        case .Unconfigured:
            UnconfiguredView()
        case .NotFound:
            NotFoundView()
        case .Unsupported:
            UnsupportedView()
        case .Success:
            BasicAssetView(
                item: entry.data!,
                displayInfo: entry.displayInfo
            )
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
