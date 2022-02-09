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
    let cornerRadius = 8.0
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
//                        ForEach(TestData.assets) { asset in
                            AssetCard(item: asset)
                                .frame(width: geo.size.width - 1.5 * spacing)
                                .frame(height: (geo.size.width -  1.5 * spacing) + 58)
                                .cornerRadius(cornerRadius)
                                .shadow(radius: boxShadowRadius)
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
                                Image(
                                    uiImage: UIImage(named: "Icon_Black")!
                                )
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .background(.white)
                                .cornerRadius(16)
                            }
                        }
                    )
                    ToolbarItem(
                        placement: .navigationBarTrailing,
                        content: {
                            Button("Connect", action: { viewModel.presentConnectSheet() })
                                .sheet(isPresented: $viewModel.showingConnectSheet) {
                                    NavigationView {
                                        ConnectSheet()
                                    }
                            }

                        }
                    )
                })
                .onAppear {
                    viewModel.load()
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
