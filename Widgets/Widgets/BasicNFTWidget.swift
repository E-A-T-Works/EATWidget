//
//  BasicNFTWidget.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import WidgetKit
import SwiftUI

struct BasicNFTWidgetProvider: IntentTimelineProvider {
    
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
        completion(
            BasicNFTWidgetEntry(
                date: Date(),
                kind: .Placeholder,
                displayInfo: false,
                data: nil
            )
        )
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
        
        Task {
            do {
                let data = try await NFTProvider.fetchNFT(contractAddress: contractAddress!, tokenId: tokenId!)
                
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
                
            } catch {
                print("⚠️ BasicNFTWidget::getTimeline: \(error)")
                
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
            
        }
    }
}


struct BasicNFTWidgetEntry: TimelineEntry {
    let date: Date
    let kind: WidgetEntryKind
    let displayInfo: Bool
    let data: NFT?
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
        .description("Choose an NFT to display.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
    
}
