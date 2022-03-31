//
//  GalleryWidget.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/16/22.
//

import WidgetKit
import SwiftUI

struct GalleryWidgetProvider: IntentTimelineProvider {
    
    private let nftStorage = CachedNFTStorage.shared
    
    func placeholder(
        in context: Context
    ) -> GalleryWidgetEntry {
        return GalleryWidgetEntry(
            date: Date(),
            kind: .Placeholder,
            data: nil
        )
    }
    
    func getSnapshot(
        for configuration: GalleryOptionsIntent,
        in context: Context,
        completion: @escaping (GalleryWidgetEntry) -> Void
    ) {

        let cached = nftStorage.fetch()
        
        if cached.isEmpty {
            
            completion(
                GalleryWidgetEntry(
                    date: Date(),
                    kind: .Unconfigured,
                    data: nil
                )
            )
            return
            
        } else if cached.count < 4 {
            
            let selection = cached
            
            completion(
                GalleryWidgetEntry(
                    date: Date(),
                    kind: .Success,
                    data: selection
                )
            )
            return
            
        } else {

            let selection = Array(cached.shuffled().prefix(4))
            
            completion(
                GalleryWidgetEntry(
                    date: Date(),
                    kind: .Success,
                    data: selection
                )
            )
            return
            
        }
    }
    
    func getTimeline(
        for configuration: GalleryOptionsIntent,
        in context: Context,
        completion: @escaping (Timeline<GalleryWidgetEntry>) -> Void
    ) {
        
        //
        //  Parse intent configuration
        //
        
        
        let selection = configuration.NFT?.map({ pick -> [String?] in
            let identifier = pick.identifier
            
            if identifier == "RANDOM" {
                return ["RANDOM", "RANDOM"]
            }
            
            let contractAddress = identifier?.components(separatedBy: "/").first
            let tokenId = identifier?.components(separatedBy: "/").last
            
            return [contractAddress, tokenId]
        }).filter({ item -> Bool in
            return item[0] != nil && item[1] != nil
        }) as? [[String]] ?? []
        
        // Placeholder if empty

        if selection.isEmpty {
            let timeline = Timeline(
                entries: [
                    GalleryWidgetEntry(
                        date: Date(),
                        kind: .Unconfigured,
                        data: nil
                    )
                ],
                policy: .never
            )
            completion(timeline)
            return
        }
        
        getTimelineForSelection(
            for: selection,
               completion: completion
        )
        return
        
        
    }
    
    // MARK: - Helpers
    
    private func getTimelineForSelection(
        for selection: [[String]],
        completion: @escaping (Timeline<GalleryWidgetEntry>) -> Void
    ) {
        
        //
        // Map onto data
        //
        
        let cached = nftStorage.fetch()
        
        let data: [CachedNFT?] = selection.map({ pick in
            
            if pick.contains("RANDOM") {
                return cached.randomElement()
            } else {
                return cached.first { item in
                    return item.address! == pick[0] && item.tokenId! == pick[1]
                }
            }
        })
        
        let cleanedData: [CachedNFT] = data.compactMap { $0 }

        let timeline = Timeline(
            entries: [
                GalleryWidgetEntry(
                    date: Date(),
                    kind: .Success,
                    data: cleanedData
                )
            ],
            policy: .never
        )
        completion(timeline)
        return
        
    }
    
}


struct GalleryWidgetEntry: TimelineEntry {
    let date: Date
    let kind: WidgetEntryKind
    let data: [CachedNFT]?
}


struct GalleryWidgetEntryView : View {
    var entry: GalleryWidgetProvider.Entry
    
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
            GalleryView(
                list: entry.data!
            )
        }
    }
}


struct GalleryWidget: Widget {
    let kind: String = "GalleryWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: GalleryOptionsIntent.self,
            provider: GalleryWidgetProvider()
        ) { entry in
            GalleryWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NFT Gallery")
        .description("Choose a set of NFTs to display side by side.")
        .supportedFamilies([.systemMedium])
    }
    
}
