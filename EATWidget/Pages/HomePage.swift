//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct HomePage: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Namespace var animation
    
    @StateObject private var viewModel: HomePageViewModel
    
    @State var brandingIcon: Int = 0
    

    init() {
        self._viewModel = StateObject(wrappedValue: HomePageViewModel())
        
        LayoutHelpers.stylePageTitle()
    }
    
    // MARK: Body
   
    var body: some View {
        ZStack {
            
            if viewModel.loading {

                ViewLoader()

            } else {

                if viewModel.nfts.isEmpty {

                    ViewPlaceholder(
                        text: "Connect a wallet to see your NFTs"
                    )

                } else {
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Text("Learn about iOS widgets")
                                .font(.system(size: 12, design: .monospaced))
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 124)
                        .background(.black)
                        .foregroundColor(.white)
                        .padding(10)
                        .onTapGesture {
                            viewModel.presentTutorialSheet()
                        }
                        
                        ForEach(viewModel.collections) { collection in
                            Text(collection.title ?? "Uknown")
                        }
                        
//                        ForEach(viewModel.addresses, id: \.self) { address in
//
//                            VStack {
//                                NavigationLink(
//                                    destination: CollectionPage(address: address)
//                                ) {
//                                    HStack {
//                                        HeadingLockup(title: address.formattedWeb3, text: nil, size: 16.0)
//                                        Spacer()
//                                    }
//                                    .padding([.horizontal], 10)
//                                }.buttonStyle(.plain)
//
//                                Divider()
//                                    .padding([.horizontal], 10)
//
//                                StaggeredGrid(
//                                    list: viewModel.nfts.filter { $0.address == address },
//                                    columns: viewModel.determineColumns(vertical: verticalSizeClass, horizontal: horizontalSizeClass),
//                                    spacing: 10,
//                                    lazy: true,
//                                    content: { item in
//                                        NFTCard(item: item)
//                                            .matchedGeometryEffect(id: item.id, in: animation)
//                                            .onTapGesture {
//
//                                                guard
//                                                    let address = item.address,
//                                                    let tokenId = item.tokenId
//                                                else { return}
//
//                                                viewModel.presentNFTDetailsSheet(address: address, tokenId: tokenId)
//                                            }
//                                    }
//                                )
//                                .padding([.horizontal], 10)
//                            }
//
//                        }
//                        .animation(.easeInOut, value: viewModel.addresses.count + 1)

                    }
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
                        // TODO: Think of what to do w this...
                        brandingIcon = Int.random(in: 0..<6)
                    } label: {
                        Branding(seed: brandingIcon)
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
                                        Text(wallet.title ?? (wallet.address ?? "").formattedWeb3)
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
                
            case .Wallets:
                NavigationView {
                    WalletsSheet()
                }
                
            case .Tutorial:
                TutorialSheet()
                
            case .MailForm(let data):
                MailView(data: data) { result in
                    print()
                }
            }
        }
    }
    
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomePage()
        }
        .previewInterfaceOrientation(.portrait)
    }
}
