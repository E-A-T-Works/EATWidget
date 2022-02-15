//
//  RandomNFTWidget.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import WidgetKit
import SwiftUI

struct RandomNFTWidgetProvider: IntentTimelineProvider {
    func placeholder(
        in context: Context
    ) -> RandomNFTWidgetEntry {
        return RandomNFTWidgetEntry(
            date: Date(),
            kind: .Placeholder,
            displayInfo: false,
            data: nil
        )
    }
    
    func getSnapshot(
        for configuration: RandomNFTOptionsIntent,
        in context: Context,
        completion: @escaping (RandomNFTWidgetEntry) -> Void
    ) {
        completion(
            RandomNFTWidgetEntry(
                date: Date(),
                kind: .Placeholder,
                displayInfo: false,
                data: nil
            )
        )
    }
    
    func getTimeline(
        for configuration: RandomNFTOptionsIntent,
        in context: Context,
        completion: @escaping (Timeline<RandomNFTWidgetEntry>) -> Void
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
                    RandomNFTWidgetEntry(
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
        
        
        let ownerAddress = preferredAddress != nil ? preferredAddress : wallets.map { $0.address! }.randomElement()
        
                
        //
        //  Fetch relevent data
        //
        
        Task {
            do {
                let data = try await NFTProvider.fetchRandomNFT(ownerAddress: ownerAddress!)
                
                let timeline = Timeline(
                    entries: [
                        RandomNFTWidgetEntry(
                            date: Date(),
                            kind: .Success,
                            displayInfo: displayInfo,
                            data: data
                        )
                    ],
                    policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
                )
                completion(timeline)
                return
                
            } catch {
                print("⚠️ RandomNFTWidget::getTimeline: \(error)")
                
                let timeline = Timeline(
                    entries: [
                        RandomNFTWidgetEntry(
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


struct RandomNFTWidgetEntry: TimelineEntry {
    let date: Date
    let kind: WidgetEntryKind
    let displayInfo: Bool
    let data: NFT?
}


struct RandomNFTWidgetEntryView : View {
    var entry: RandomNFTWidgetProvider.Entry
    
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
            BasicNFTView(
                item: entry.data!,
                displayInfo: entry.displayInfo
            )
        }
    }
}


struct RandomNFTWidget: Widget {
    let kind: String = "RandomNFTWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: RandomNFTOptionsIntent.self,
            provider: RandomNFTWidgetProvider()
        ) { entry in
            RandomNFTWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random NFT")
        .description("View a random NFT from your collection.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
    
}
