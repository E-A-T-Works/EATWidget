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
            
//            if viewModel.loading {
//                ViewLoader()
//            } else {
            
            
            
                
                ScrollView {
                    
                    CollectionVisual(
                        url: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2F0xf9a423b86afbf8db41d7f24fa56848f56684e43f%2Fbanner.png?alt=media&token=e6f96e72-067e-4c02-bcbe-c5f0d0288e20")!
                    )
                    
                    CollectionHeader(
                        title: "Every Icon",
                        address: "0x000000000000000000"
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                
                    CreatorItem(title: "John Simon Jr")
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                    CollectionDescription(
                        text: "A re-imagining of Every Icon, John F. Simon Jr.'s seminal web-based software art work first released in 1997.  This blockchain-native, on-chain expression was created by John F. Simon Jr. and divergence, in collaboration with FingerprintsDAO and e•a•t•}works"
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                
                    ActionRow(
                        list: [
                            ActionRowButton(target: .Other, url: URL(string: "https://google.com")!),
                            ActionRowButton(target: .Discord, url: URL(string: "https://google.com")!),
                            ActionRowButton(target: .Twitter, url: URL(string: "https://google.com")!),
                            ActionRowButton(target: .Etherscan, url: URL(string: "https://google.com")!)
                        ]
                    )
                    .padding(.horizontal)
                    .padding(.vertical)
                    
                    Divider().padding()
                    
                    
                    
                        
                        // paginate everything else
                    
                    
                    
                    ForEach(0..<100, id: \.self) { i in
                        Text("hihi \(i)")
                    }
                }
            
            
            
            
            
                
                
                
                
//            }
            
            
//                TabView(selection: $viewModel.tab) {
//
//                    CollectionAssetsPage()
//                        .ignoresSafeArea()
//                        .tag(CollectionPageTabs.list)
//
//                    CollectionDetailsPage()
//                        .ignoresSafeArea()
//                        .tag(CollectionPageTabs.detail)
//                }
             
            
            
//            HStack(spacing: 0) {
//
//                Button {
//                    viewModel.changeTabs(to: .list)
//                } label: {
//                    Image(systemName: "square.grid.2x2")
//                        .padding()
//                        .frame(width: 64, height: 56)
//                        .background(viewModel.tab == .list ? .white : .white.opacity(0.0))
//                        .foregroundColor(.black)
//                        .cornerRadius(22)
//                }.padding(.horizontal, 4)
//
//                HStack { Divider().padding(.vertical).padding(.horizontal, 4) }
//
//                Button {
//                    viewModel.changeTabs(to: .detail)
//                } label: {
//                    Image(systemName: "doc.plaintext")
//                        .padding()
//                        .frame(width: 64, height: 56)
//                        .background(viewModel.tab == .detail ? .white : .white.opacity(0.0))
//                        .foregroundColor(.black)
//                        .cornerRadius(22)
//                }.padding(.horizontal, 4)
//
//            }
//            .background(.thickMaterial)
//            .cornerRadius(26)
//            .frame(width: 180, height: 64)
        }
        .ignoresSafeArea()
    }
}

struct CollectionPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionPage(address: "0xf9a423b86afbf8db41d7f24fa56848f56684e43")
        }.previewInterfaceOrientation(.portrait)
        
    }
}
