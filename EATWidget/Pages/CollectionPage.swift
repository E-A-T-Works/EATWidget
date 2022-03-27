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
                    
                    CollectionSection(item: TestData.collection)
                    
                    Divider().padding()
                    
                    // in current collection
                    
                    ForEach(0..<100, id: \.self) { i in
                        Text("hihi \(i)")
                    }
                    
                    
                    // everything else
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
