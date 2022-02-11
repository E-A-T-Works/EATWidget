//
//  AssetSheetActions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

enum AssetSheetActionButtonTarget {
    case Opensea
    case Etherscan
    case Twitter
    case Discord
}

struct AssetSheetActionButtons {
    let target: AssetSheetActionButtonTarget
    let url: URL
    
    var image: UIImage {
        switch target {
        case .Opensea:
            return UIImage(named: "Opensea")!
        case .Etherscan:
            return UIImage(named: "Etherscan")!
        case .Twitter:
            return UIImage(named: "Twitter")!
        case .Discord:
            return UIImage(named: "Discord")!
        }
    }
    
    var title: String {
        switch target {
        case .Opensea:
            return "Opensea"
        case .Etherscan:
            return "Etherscan"
        case .Twitter:
            return "Twitter"
        case .Discord:
            return "Discord"
        }
    }
}

struct AssetSheetActions: View {
    
    let list: [AssetSheetActionButtons]
    
    private func hideText() -> Bool {
        return list.count > 2
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                ForEach(list, id: \.target) { item in
                    URLButton(
                        url: item.url,
                        image: item.image,
                        title: hideText() ? nil : item.title
                    )
                }
            }
        }
    }
}

struct AssetSheetActions_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AssetSheetActions(
                list: [
                    AssetSheetActionButtons(
                        target: .Opensea,
                        url: URL(string: "https://google.com")!
                    ),
                    
                    AssetSheetActionButtons(
                        target: .Etherscan,
                        url: URL(string: "https://google.com")!
                    ),

                    AssetSheetActionButtons(
                        target: .Twitter,
                        url: URL(string: "https://google.com")!
                    ),
                    
                    AssetSheetActionButtons(
                        target: .Discord,
                        url: URL(string: "https://google.com")!
                    )
                ]
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
