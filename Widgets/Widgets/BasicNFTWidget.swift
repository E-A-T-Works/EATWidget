//
//  BasicNFTWidget.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import WidgetKit
import SwiftUI

struct BasicNFTWidgetProvider: IntentTimelineProvider {
    
    private let walletStorage = CachedWalletStorage.shared
    private let nftStorage = CachedNFTStorage.shared
    
    func placeholder(
        in context: Context
    ) -> BasicNFTWidgetEntry {
        return BasicNFTWidgetEntry(
            date: Date(),
            kind: .Placeholder,
            displayInfo: false,
            data: nil
        )
    }
    
    func getSnapshot(
        for configuration: BasicNFTOptionsIntent,
        in context: Context,
        completion: @escaping (BasicNFTWidgetEntry) -> Void
    ) {

        guard let data = nftStorage.fetch().randomElement() else {
            completion(
                BasicNFTWidgetEntry(
                    date: Date(),
                    kind: .Unconfigured,
                    displayInfo: false,
                    data: nil
                )
            )
            return
        }
        
        completion(
            BasicNFTWidgetEntry(
                date: Date(),
                kind: .Success,
                displayInfo: [true, false].randomElement()!,
                data: data
            )
        )
        return
        
    }
    
    func getTimeline(
        for configuration: BasicNFTOptionsIntent,
        in context: Context,
        completion: @escaping (Timeline<BasicNFTWidgetEntry>) -> Void
    ) {
        //
        //  Parse intent configuration
        //
        
        let identifier = configuration.NFT?.identifier
        
        if identifier != "RANDOM" {
            getTimelineForSpecificNFT(for: configuration, completion: completion)
        } else {
            getTimelineForRandomNFT(for: configuration, completion: completion)
        }
    }
    
    // MARK: - Helpers
    
    private func getTimelineForRandomNFT(
        for configuration: BasicNFTOptionsIntent,
        completion: @escaping (Timeline<BasicNFTWidgetEntry>) -> Void
    ) {
        let preferredAddress = configuration.Wallet?.identifier
        let displayInfo = configuration.DisplayInfo?.boolValue ?? false
        
        let wallets = walletStorage.fetch()
        
        if wallets.isEmpty {
            let timeline = Timeline(
                entries: [
                    BasicNFTWidgetEntry(
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
        
        let options = nftStorage.fetch().filter { $0.wallet?.address == ownerAddress }
        
        guard let data = options.randomElement() else {
            let timeline = Timeline(
                entries: [
                    BasicNFTWidgetEntry(
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
        
        let timeline = Timeline(
            entries: [
                BasicNFTWidgetEntry(
                    date: Date(),
                    kind: .Success,
                    displayInfo: displayInfo,
                    data: data
                )
            ],
            policy: .after(
                Calendar.current.date(
                    byAdding: .hour,
                    value: 1,
                    to: Date()
                )!
            )
        )
        
        completion(timeline)
    }
    
    
    private func getTimelineForSpecificNFT(
        for configuration: BasicNFTOptionsIntent,
        completion: @escaping (Timeline<BasicNFTWidgetEntry>) -> Void
    ){
        
        let identifier = configuration.NFT?.identifier
        
        let contractAddress = identifier?.components(separatedBy: "/").first
        let tokenId = identifier?.components(separatedBy: "/").last
        
        let displayInfo = configuration.DisplayInfo?.boolValue ?? false
        
        
        if contractAddress == nil || tokenId == nil {
            
            let timeline = Timeline(
                entries: [
                    BasicNFTWidgetEntry(
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
        
        let options = nftStorage.fetch()
        
        guard let data = (options.first { $0.address == contractAddress && $0.tokenId == tokenId }) else {
            let timeline = Timeline(
                entries: [
                    BasicNFTWidgetEntry(
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
        
        let timeline = Timeline(
            entries: [
                BasicNFTWidgetEntry(
                    date: Date(),
                    kind: .Success,
                    displayInfo: displayInfo,
                    data: data
                )
            ],
            policy: .never
        )
        completion(timeline)
        return
    }
}


struct BasicNFTWidgetEntry: TimelineEntry {
    let date: Date
    let kind: WidgetEntryKind
    let displayInfo: Bool
    let data: CachedNFT?
}


struct BasicNFTWidgetEntryView : View {
    var entry: BasicNFTWidgetProvider.Entry
    
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


struct BasicNFTWidget: Widget {
    let kind: String = "BasicNFTWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: BasicNFTOptionsIntent.self,
            provider: BasicNFTWidgetProvider()
        ) { entry in
            BasicNFTWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NFT")
        .description("Choose an NFT to display on your homescreen.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
    
}
