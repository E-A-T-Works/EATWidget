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
        List() {
            ForEach(viewModel.wallets) { wallet in
                Section(header: Text(wallet.address!)) {
                    ForEach(viewModel.assetsByWallet[wallet.address!] ?? []) { asset in
                        
                        NavigationLink(
                            destination: AssetPage(
                                contractAddress: asset.contract.address,
                                tokenId: asset.tokenId
                            )
                        ) {
                            AssetItem(item: asset)
                        }
                        
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Collection")
        .toolbar(content: {
            ToolbarItem(
                placement: .navigationBarTrailing,
                content: {
                    Button("Connect", action: { viewModel.presentConnectSheet() })
                        .sheet(isPresented: $viewModel.showingConnectSheet) {
                            NavigationView {
                                ConnectSheet()
                            }
                    }
                    
                    
//                    Button(action: viewModel.presentConnectSheet, label: { Image(systemName: "plus") })
                    
                    
//                    Button("Connect", action: viewModel.presentConnectSheet)
//                        .sheet(isPresented: $viewModel.showingConnectSheet) {
//                            NavigationView {
//                                ConnectPage()
//                            }
//                    }
////
//                    Button {
//                        viewModel.presentConnectSheet()
//                    } label: {
//                        Image(systemName: "plus")
//                    }
                }
            )
        })
        .onAppear {
            viewModel.load()
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
