//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct CollectionPage: View {
    @StateObject private var viewModel = CollectionPageViewModel()
    
    init() {
        Theme.navigationBarColors(
            background: Theme.backgroundColorForPage(),
            titleColor: Theme.foregroundColorForPage(),
            tintColor: Theme.foregroundColorForPage()
       )
    }

    let spacing = 16.0
    let cornerRadius = 12.0
    let boxShadowRadius = 8.0
    
    var body: some View {

        GeometryReader { geo in
            ZStack {
                Color(uiColor: Theme.backgroundColorForPage()).ignoresSafeArea(.all)
                
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible(minimum: geo.size.width, maximum: geo.size.width), spacing: 0)],
                        alignment: .center, spacing: spacing
                    ) {
                        ForEach(viewModel.assets) { asset in
                            AssetCard(item: asset)
                                .frame(width: geo.size.width - 1.5 * spacing)
                                .frame(height: (geo.size.width -  1.5 * spacing) + 58)
                                .cornerRadius(cornerRadius)
                                .shadow(radius: boxShadowRadius)
                                .onTapGesture {
                                    viewModel.presentAssetSheet(
                                        contractAddress: asset.contract.address,
                                        tokenId: asset.tokenId
                                    )   
                                }
                        }
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
}


struct CollectionPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionPage()
        }
    }
}
