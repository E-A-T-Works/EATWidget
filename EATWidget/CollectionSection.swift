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
            
            HStack {
                Text("\(address.formattedWeb3)")
                Spacer()
            }
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
            CollectionSection(address: "123", filterBy: nil) { address, tokenId in
                // pass
            }
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
