//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct CollectionPage: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = CollectionPageViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.loading {
                ViewLoader()
            } else {
                
                if viewModel.empty {
                    
                    Text("Empty Placeholder")
                    
                } else {
                
                    StaggeredGrid(
                        list: viewModel.nfts,
                        columns: viewModel.columns,
                        showsIndicators: false,
                        spacing: 10,
                        lazy: true,
                        content: { item in
                            NFTCard(item: item)
                                .onTapGesture {
                                    viewModel.presentAssetSheet(
                                        contractAddress: item.address!,
                                        tokenId: item.tokenId!
                                    )
                                }
                        }
                    )
                    .padding([.horizontal], 10)

                }
                
                
                
                FeedbackPrompt(
                    title: "Share Feedback",
                    action: { viewModel.presentMailFormSheet() }
                )
            }
        }
        .navigationTitle("Collection")
        .toolbar(content: {
            ToolbarItem(
                placement: .navigationBarLeading,
                content: {
                    Button {
                        // TODO: Think of what this does
                    } label: {
                        Branding()
                            .frame(width: 32, height: 32)
                    }
                }
            )
            ToolbarItem(
                placement: .navigationBarTrailing,
                content: {
                    
                    Menu(content: {
                        ForEach(viewModel.wallets) { wallet in
                            Button(action: {
                                viewModel.setFilterBy(wallet: wallet)
                            }, label: {
                                Text(wallet.title ?? wallet.address!)
                            })
                        }
                        
                        Button(action: {
                            viewModel.presentConnectSheet()
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Connect Wallet")
                            }
                        })
                    }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    })

                }
            )
        })
        .sheet(isPresented: $viewModel.showingSheet) {
            switch viewModel.sheetContent {
            case .ConnectForm:
                NavigationView {
                    ConnectSheet()
                }
                
            case .NFTDetails(let contractAddress, let tokenId):
                NFTSheet(
                    contractAddress: contractAddress,
                    tokenId: tokenId
                )
                
            case .MailForm(let data):
                MailView(data: data) { result in
                    print()
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
