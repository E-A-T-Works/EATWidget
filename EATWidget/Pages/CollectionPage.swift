//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct CollectionPage: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Namespace var animation
    
    @StateObject private var viewModel = CollectionPageViewModel()
    
    // MARK: Calculated Values

    var list: [NFTObject] {
        if viewModel.filterBy != nil {
            return viewModel.nfts.filter { $0.wallet!.address! == viewModel.filterBy!.address }
        }
        
        return viewModel.nfts
    }

    // MARK: Body
   
    var body: some View {
        ZStack {
            
            if viewModel.loading {

                ViewLoader()

            } else {

                if list.isEmpty {

                    ViewPlaceholder(text: "Connect a wallet to see your NFTs")

                } else {
                    StaggeredGrid(
                        list: list,
                        columns: viewModel.determineColumns(vertical: verticalSizeClass, horizontal: horizontalSizeClass),
                        showsIndicators: false,
                        spacing: 10,
                        lazy: true,
                        content: { item in
                            NFTCard(item: item)
                                .matchedGeometryEffect(id: item.id, in: animation)
                                .onTapGesture {
                                    viewModel.presentNFTDetailsSheet(
                                        address: item.address!,
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
        .animation(.easeInOut, value: list.count + 1)
        .navigationTitle("Collection")
        .toolbar(content: {
            ToolbarItem(
                placement: .navigationBarLeading,
                content: {
                    Button {
                        // TODO: Think of what to do w this...
                    } label: {
                        Branding()
                            .frame(width: 32, height: 32)
                    }
                }
            )
            
            ToolbarItem(
                placement: .navigationBarTrailing,
                content: {

                    if viewModel.wallets.isEmpty {

                        Button(action: {
                            viewModel.presentConnectSheet()
                        }, label: {
                            Text("connect")
                                .font(.system(size: 16, design: .monospaced))
                        })
                        
                    } else if viewModel.filterBy != nil {
                        
                        Button(action: {
                            viewModel.clearFilterBy()
                        }, label: {
                            HStack {
                                Text(viewModel.filterBy!.title ?? viewModel.filterBy!.address!.formattedWeb3)
                                    .font(.system(size: 16, design: .monospaced))
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, design: .monospaced))
                            }
                            
                        }).buttonStyle(.bordered)
                        
                    } else {
                        
                        Menu(content: {
                            Section {
                                ForEach(viewModel.wallets) { wallet in
                                    Button(action: {
                                        viewModel.setFilterBy(wallet: wallet)
                                    }, label: {
                                        Text(wallet.title ?? wallet.address!.formattedWeb3)
                                    })
                                }
                            }
                            
                            Section {
                                Button(action: {
                                    viewModel.presentWalletsSheet()
                                }, label: {
                                    HStack {
                                        Image(systemName: "slider.horizontal.3")
                                        Text("Manage Wallets")
                                    }
                                })
                                
                                Button(action: {
                                    viewModel.presentConnectSheet()
                                }, label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Connect Wallet")
                                    }
                                })
                            }
                        }, label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        })
                        
                    }
                }
            )
        })
        .sheet(isPresented: $viewModel.showingSheet) {
            switch viewModel.sheetContent {
            case .ConnectForm:
                NavigationView {
                    ConnectSheet()
                }
                
            case .NFTDetails(let address, let tokenId):
                NFTSheet(
                    address: address,
                    tokenId: tokenId
                )
                
            case .NFTWallets:
                NavigationView {
                    WalletsSheet()
                }
                
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
        .previewInterfaceOrientation(.portrait)
    }
}
