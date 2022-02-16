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
                
                
                // Contact
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.presentMailFormSheet()
                        }, label: {
                            Text("Share Feedback")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                .padding(8)
                        })
                            .background(colorScheme == .dark ? Color.white : Color.black)
                            .shadow(radius: 2)
                            .padding()
                            
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
                    ConnectSheet().onDisappear {
                        // TODO: This has to be smarter
                        viewModel.load()
                    }
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
