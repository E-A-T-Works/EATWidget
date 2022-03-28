//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/25/22.
//

import SwiftUI

struct CollectionPage: View {
    let address: String
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Namespace var animation
    
    @StateObject private var viewModel: CollectionPageViewModel
    
    @State var brandingIcon: Int = 0
    
    init(address: String) {
        self.address = address
        
        self._viewModel = StateObject(wrappedValue: CollectionPageViewModel(address: address))
        
        LayoutHelpers.stylePageTitle()
        
        UITabBar.appearance().isHidden = true
    }
    
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            
            if viewModel.collection == nil {
                
                ViewLoader()
                
            } else {

                ScrollView {
                    
                    CollectionSection(item: viewModel.collection!)
                    
                    Divider().padding()
                    
                    StaggeredGrid(
                        list: viewModel.collected,
                        columns: viewModel.determineColumns(vertical: verticalSizeClass, horizontal: horizontalSizeClass),
                        spacing: 10,
                        lazy: true,
                        content: { item in
                            NFTCard(item: item)
                                .matchedGeometryEffect(id: item.id, in: animation)
                                .onTapGesture {
                                    
                                    guard
                                        let address = item.address,
                                        let tokenId = item.tokenId
                                    else { return}
                                    
                                    viewModel.presentNFTDetailsSheet(address: address, tokenId: tokenId)
                                }
                        }
                    )
                    .padding(.horizontal)
                    
                    Divider().padding()
                    
                    Text("Everything else")
                }
    
            }
        }
        .ignoresSafeArea()
//        .navigationTitle("Every Icon")
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            EmptyView()
        })
        .sheet(isPresented: $viewModel.showingSheet) {
            switch viewModel.sheetContent {
            case .NFTDetails(let address, let tokenId):
                NFTSheet(
                    address: address,
                    tokenId: tokenId
                )
            case .MailForm(let data):
                MailView(data: data) { result in
                    print()
                }
            case .none:
                EmptyView()
            }
        }
    }
}

struct CollectionPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionPage(address: "0xf9a423b86afbf8db41d7f24fa56848f56684e43")
        }.previewInterfaceOrientation(.portrait)
        
    }
}
