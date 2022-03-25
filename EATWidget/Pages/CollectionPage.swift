//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/25/22.
//

import SwiftUI

struct CollectionPage: View {
    let address: String
    let tabs: [String] = ["list", "creator", "project"]
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: CollectionPageViewModel
    
    @State var brandingIcon: Int = 0
    @State var selectedTab: String = "list"
    
    init(address: String) {
        self.address = address
        
        self._viewModel = StateObject(wrappedValue: CollectionPageViewModel(address: address))
        
        LayoutHelpers.stylePageTitle()
        
        UITabBar.appearance().isHidden = true
    }
    
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                
                VStack {
                 
                    if viewModel.collection != nil {
                        URLImage(url: viewModel.collection!.thumbnail)
                    } else {
                        Text("loading")
                    }
                    
                }
                    .ignoresSafeArea()
                    .tag("list")
                
                Color(.green)
                    .ignoresSafeArea()
                    .tag("creator")
                
                Color(.yellow)
                    .ignoresSafeArea()
                    .tag("project")
            }
            
            HStack {
                
                ForEach(tabs, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Text("\(tab)")
                    }
                    .padding()
                    
                    if tab != tabs.last { Spacer() }
                    
                }
            }
            .background(.white)
            .padding()
        }

        
//
//        ZStack {
//            VStack {
//                VStack {
//                    URLImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2F0xf9a423b86afbf8db41d7f24fa56848f56684e43f%2Fbanner.png?alt=media&token=e6f96e72-067e-4c02-bcbe-c5f0d0288e20")!)
//                }.ignoresSafeArea()
//
//                VStack {
//                    HStack {
//                        URLImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/eatworks-36a21.appspot.com/o/contracts%2F0xf9a423b86afbf8db41d7f24fa56848f56684e43f%2Fthumbnail.png?alt=media&token=17039284-d6ab-4371-bbd3-23b76960dd06")!).frame(width: 100, height: 100)
//
//                        Text("Hello")
//
//                        Spacer()
//                    }
//                }
//
//                Spacer()
//            }
//
//
//        }
//        .navigationTitle("Every Icon")

    }
}

struct CollectionPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionPage(address: "0xf9a423b86afbf8db41d7f24fa56848f56684e43")
        }
        
    }
}
