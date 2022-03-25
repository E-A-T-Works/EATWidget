//
//  CollectionSection.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/15/22.
//

import SwiftUI

struct CollectionSection: View {
    let address: String
    var filterBy: NFTWallet?
    
    let action: (_ address:String, _ tokenId:String) -> Void
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @StateObject private var viewModel:CollectionSectionViewModel
    
    @Namespace var animation
    
    init(address: String, filterBy: NFTWallet?, action: @escaping (_ address:String, _ tokenId:String) -> Void) {
        self.address = address
        self.filterBy = filterBy
        self.action = action
        
        self._viewModel = StateObject(wrappedValue: CollectionSectionViewModel(address: address))
    }
    
    
    var list: [NFTObject] {
        
        guard filterBy != nil else {
            return viewModel.nfts
        }
        
        return viewModel.nfts.filter { $0.wallet!.address! == filterBy!.address }
    }
    
    var body: some View {
        
        VStack {
            
            NavigationLink(
                destination: CollectionPage(address: address)
            ) {
                HStack {
                    HeadingLockup(title: address.formattedWeb3, text: nil, size: 16.0)
                    Spacer()
                }
                .padding([.horizontal], 10)
            }.buttonStyle(.plain)
            
            
            Divider()
                .padding([.horizontal], 10)

            StaggeredGrid(
                list: list,
                columns: viewModel.determineColumns(vertical: verticalSizeClass, horizontal: horizontalSizeClass),
                spacing: 10,
                lazy: true,
                content: { item in
                    NFTCard(item: item)
                        .matchedGeometryEffect(id: item.id, in: animation)
                        .onTapGesture {
                            action(item.address!, item.tokenId!)
                        }
                }
            )
            .padding([.horizontal], 10)

        }
        .padding(.bottom)
        .animation(.easeInOut, value: list.count + 1)
   
    }
}

struct CollectionSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollectionSection(
                address: "0xf9a423b86afbf8db41d7f24fa56848f56684e43f",
                filterBy: nil
            ) { address, tokenId in
                // pass
            }
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
