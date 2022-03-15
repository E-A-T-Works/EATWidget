//
//  CollectionSection.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/15/22.
//

import SwiftUI

struct CollectionSection: View {
    let address: String
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @StateObject private var viewModel:CollectionSectionViewModel
    
    @Namespace var animation
    
    init(address: String) {
        self.address = address
        
        self._viewModel = StateObject(wrappedValue: CollectionSectionViewModel(address: address))
    }
    
    
    var list: [NFTObject] {
//        if viewModel.filterBy != nil {
//            return viewModel.nfts.filter { $0.wallet!.address! == viewModel.filterBy!.address }
//        }
        
        return viewModel.nfts
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("\(address.formattedWeb3)")
                Spacer()
            }
                        
            StaggeredGrid(
                list: list,
                columns: viewModel.determineColumns(vertical: verticalSizeClass, horizontal: horizontalSizeClass),
                spacing: 10,
                lazy: true,
                content: { item in
                    NFTCard(item: item)
                        .matchedGeometryEffect(id: item.id, in: animation)
                        .onTapGesture {

                        }
                }
            )
            .padding([.horizontal], 10)
            
            Divider()
            
        }
        
        
    }
}

struct CollectionSection_Previews: PreviewProvider {
    static var previews: some View {
        CollectionSection(address: "123")
    }
}
