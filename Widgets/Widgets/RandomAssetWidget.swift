//
//  RandomAssetWidget.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import WidgetKit
import SwiftUI

struct RandomAssetWidgetProvider: IntentTimelineProvider {
    func placeholder(
        in context: Context
    ) -> RandomAssetWidgetEntry {
        return RandomAssetWidgetEntry(
            date: Date(),
            kind: AssetWidgetEntryKind.Placeholder,
            displayInfo: false,
            data: nil
        )
    }
    
    func getSnapshot(
        for configuration: RandomAssetOptionsIntent,
        in context: Context,
        completion: @escaping (RandomAssetWidgetEntry) -> Void
    ) {
        completion(
            RandomAssetWidgetEntry(
                date: Date(),
                kind: AssetWidgetEntryKind.Placeholder,
                displayInfo: false,
                data: nil
            )
        )
    }
    
    func getTimeline(
        for configuration: RandomAssetOptionsIntent,
        in context: Context,
        completion: @escaping (Timeline<RandomAssetWidgetEntry>) -> Void
    ) {
        //
        //  Parse intent configuration
        //
        
        let preferredAddress = configuration.Wallet?.identifier
        let displayInfo = configuration.DisplayInfo?.boolValue ?? false
        
        //
        // Figure out which address to use
        //
        
        let wallets = WalletStorage.shared.fetch()
        
        if wallets.isEmpty {
            let timeline = Timeline(
                entries: [
                    RandomAssetWidgetEntry(
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
        
        
        let ownerAddress = preferredAddress != nil ? preferredAddress : wallets.map { $0.address! }.randomElement()
        
                
        //
        //  Fetch relevent data
        //
        
        Task {
            do {
                let asset = try await AssetProvider.fetchRandomAsset(ownerAddress: ownerAddress!)
                
                let timeline = Timeline(
                    entries: [
                        RandomAssetWidgetEntry(
                            date: Date(),
                            kind: AssetWidgetEntryKind.Success,
                            displayInfo: displayInfo,
                            data: asset
                        )
                    ],
                    policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
                )
                completion(timeline)
                return
                
            } catch {
                print("⚠️ RandomAssetWidget::getTimeline: \(error)")
                
                let timeline = Timeline(
                    entries: [
                        RandomAssetWidgetEntry(
                            date: Date(),
                            kind: AssetWidgetEntryKind.NotFound,
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


struct RandomAssetWidgetEntry: TimelineEntry {
    let date: Date
    let kind: AssetWidgetEntryKind
    let displayInfo: Bool
    let data: Asset?
}


struct RandomAssetWidgetEntryView : View {
    var entry: RandomAssetWidgetProvider.Entry
    
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
            AssetView(item: entry.data!, displayInfo: entry.displayInfo)
        }
    }
}


struct RandomAssetWidget: Widget {
    let kind: String = "RandomAssetWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: RandomAssetOptionsIntent.self,
            provider: RandomAssetWidgetProvider()
        ) { entry in
            RandomAssetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random NFT")
        .description("View a random NFT from your collection.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
    
}
