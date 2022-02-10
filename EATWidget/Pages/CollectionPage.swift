//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct CollectionPage: View {
    @StateObject private var viewModel = CollectionPageViewModel()
    
    @Namespace var animation
    
    var body: some View {
        GeometryReader { geo in
            StaggeredGrid(
//                list: TestData.assets,
                list: viewModel.assets,
                columns: viewModel.columns,
                showsIndicators: false,
                spacing: 10,
                content: { asset in
                    AssetCard(item: asset)
                        .matchedGeometryEffect(id: asset.id, in: animation)
                        .onTapGesture {
                            viewModel.presentAssetSheet(
                                contractAddress: asset.contract.address,
                                tokenId: asset.tokenId
                            )
                        }
                }
            )
            .padding([.horizontal], 10)
            .animation(.easeInOut, value: viewModel.columns)
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
                case .Connect:
                    ConnectSheet()
                case .Asset(let contractAddress, let tokenId): AssetSheet(
                        contractAddress: contractAddress,
                        tokenId: tokenId
                    )
                    
                }
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
