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

    
    init(address: String) {
        self.address = address

        self._viewModel = StateObject(wrappedValue: CollectionPageViewModel(address: address))
        
        LayoutHelpers.stylePageTitle()
        
//        let appearence = UINavigationBarAppearance()
//
//        appearence.backgroundImage = UIImage(named: "testing")!
//        appearence.backgroundImageContentMode = .scaleAspectFill
//        appearence.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
//
//        UINavigationBar.appearance().standardAppearance = appearence
//        UINavigationBar.appearance().compactAppearance = appearence
//        UINavigationBar.appearance().scrollEdgeAppearance = appearence
    
    }


    var body: some View {

        ScrollView {

            HStack {
                Text(address.formattedWeb3)
                    .font(.system(size: 12.0, design: .monospaced))
                    .fontWeight(.light)
                    .lineLimit(1)
                    
                Spacer()
            }
            .padding(.horizontal, 22)
            
            if viewModel.collection?.text != nil {
                HStack {
                    Text(viewModel.collection!.text!)
                    .font(.system(size: 12.0, design: .monospaced))
                    .lineSpacing(1.5)
                    
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.vertical)
            }
            
            ActionRow(
                list: viewModel.actionButtons
            )
            .padding(.vertical)
            
            VStack {
                HStack {
                
                    Text("Collected")
                        .font(.system(size: 16.0, design: .monospaced))
                        .fontWeight(.black)
                        .lineLimit(1)
                    
                    Spacer()
                }
                
                Divider()
            }
            .padding(.horizontal, 22)
            .padding(.vertical)
            
            StaggeredGrid(
                list: viewModel.collected,
                columns: viewModel.determineColumns(vertical: verticalSizeClass, horizontal: horizontalSizeClass),
                spacing: 10,
                lazy: true,
                content: { item in
                    Button {
                        guard
                            let address = item.address,
                            let tokenId = item.tokenId
                        else { return}

                        viewModel.presentNFTDetailsSheet(address: address, tokenId: tokenId)
                    } label: {
                        NFTCard(item: item)
                    }
                    .buttonStyle(.plain)
                }
            )
            .padding(.horizontal)
            
        }
        .navigationTitle(viewModel.collection?.title ?? "Unkown Collection")
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
