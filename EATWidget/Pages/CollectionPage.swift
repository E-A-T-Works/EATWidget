//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct CollectionPage: View {
    @StateObject private var viewModel = CollectionPageViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.loading {
                ViewLoader()
            }else{
                StaggeredGrid(
                    list: viewModel.list,
                    columns: viewModel.columns,
                    showsIndicators: false,
                    spacing: 10,
                    lazy: false,
                    content: { item in
                        NFTCard(item: item)
                            .onTapGesture {
                                viewModel.presentAssetSheet(
                                    contractAddress: item.address,
                                    tokenId: item.tokenId
                                )
                            }
                    }
                )
                .padding([.horizontal], 10)
            }
        }
        .navigationTitle("Collection")
        .toolbar(content: {
            ToolbarItem(
                placement: .navigationBarLeading,
                content: {
                    Button {
                        // TODO
                    } label: {
                        Branding()
                            .frame(width: 32, height: 32)
                    }
                }
            )
            ToolbarItem(
                placement: .navigationBarTrailing,
                content: {
                    Button("Connect", action: { viewModel.presentConnectSheet() })
                }
            )
        })
        .onAppear {
            viewModel.load()
        }
        .sheet(isPresented: $viewModel.showingSheet) {
            switch viewModel.sheetContent {
            case .ConnectForm:
                NavigationView {
                    ConnectSheet()
                }
            case .NFTDetails(let contractAddress, let tokenId): NFTSheet(
                    contractAddress: contractAddress,
                    tokenId: tokenId
                )
                
            }
        }
    }
    
}


struct CollectionPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionPage()
        }
    }
}
