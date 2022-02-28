//
//  ActionRow.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

enum ActionRowButtonTarget {
    case Opensea
    case Etherscan
    case Twitter
    case Discord
}

struct ActionRowButton {
    let target: ActionRowButtonTarget
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

struct ActionRow: View {
    
    let list: [ActionRowButton]
    
    private func hideText() -> Bool {
        return list.count > 3
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

struct ActionRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ActionRow(
                list: [
                    ActionRowButton(
                        target: .Opensea,
                        url: URL(string: "https://google.com")!
                    ),
                    
                    ActionRowButton(
                        target: .Etherscan,
                        url: URL(string: "https://google.com")!
                    ),

                    ActionRowButton(
                        target: .Twitter,
                        url: URL(string: "https://google.com")!
                    ),
                    
                    ActionRowButton(
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
