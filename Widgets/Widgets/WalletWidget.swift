//
//  WalletWidget.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import WidgetKit
import SwiftUI

struct WalletWidgetProvider: IntentTimelineProvider {
    
    func placeholder(
        in context: Context
    ) -> WalletWidgetEntry {
        return WalletWidgetEntry(
            date: Date(),
            kind: .Placeholder,
            data: nil
        )
    }
    
    func getSnapshot(
        for configuration: WalletOptionsIntent,
        in context: Context,
        completion: @escaping (WalletWidgetEntry) -> Void
    ) {
        completion(
            WalletWidgetEntry(
                date: Date(),
                kind: .Placeholder,
                data: nil
            )
        )
    }
    
    
    func getTimeline(
        for configuration: WalletOptionsIntent,
        in context: Context,
        completion: @escaping (Timeline<WalletWidgetEntry>) -> Void
    ) {
        //
        //  Parse intent configuration
        //
        
        let wallets = WalletStorage.shared.fetch()
        
        let walletsToRender = (configuration.Wallet?.reduce(into: [WalletINO]()) { acc, curr in
            return acc.append(curr)
        } ?? []).map { walletINO in
            wallets.first { $0.address == walletINO.identifier }
        }.filter { $0 != nil }
        
        if walletsToRender.isEmpty {
            let timeline = Timeline(
                entries: [
                    WalletWidgetEntry(
                        date: Date(),
                        kind: .Unconfigured,
                        data: nil
                    )
                ],
                policy: .never
            )
            completion(timeline)
        }

        Task {
            do {
                
                let data = try await walletsToRender.asyncMap { wallet -> WalletWidgetData in
                    let address = wallet?.address
                    
                    print("ABOUT TO PULL \(address!)")
                    
                    let balance = try await DataProvider.fetchWalletBalance(address: address!)
                    
                    return WalletWidgetData(
                        wallet: wallet!,
                        balance: balance
                    )
                }
                
                
                let timeline = Timeline(
                    entries: [
                        WalletWidgetEntry(
                            date: Date(),
                            kind: .Success,
                            data: data
                        )
                    ],
                    policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
                )
                completion(timeline)
                return
                
                
            } catch {
                print("⚠️ WalletWidget::getTimeline: \(error)")
                
                let timeline = Timeline(
                    entries: [
                        WalletWidgetEntry(
                            date: Date(),
                            kind: .NotFound,
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

struct WalletWidgetData {
    let wallet: Wallet
    let balance: String
}

struct WalletWidgetEntry: TimelineEntry {
    let date: Date
    let kind: WidgetEntryKind
    let data: [WalletWidgetData]?
}


struct WalletWidgetEntryView : View {
    var entry: WalletWidgetProvider.Entry
    
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
            let items = entry.data!.map { item in
                WalletsViewData(
                    address: item.wallet.address!,
                    title: item.wallet.title,
                    balance: item.balance
                )
            }
            
            WalletsView(items: items)
        }
    }
}


struct WalletWidget: Widget {
    let kind: String = "WalletWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: WalletOptionsIntent.self,
            provider: WalletWidgetProvider()
        ) { entry in
            WalletWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Wallet")
        .description("See info about your wallet")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
    
}
