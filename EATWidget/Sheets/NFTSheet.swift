//
//  NFTSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct NFTSheet: View {
    
    let contractAddress: String
    let tokenId: String
    
    let spacing: CGFloat = 12
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel = NFTSheetViewModel()
    
    var body: some View {
        ZStack {

            if viewModel.loading {
                ViewLoader()
            } else {
                ScrollView {
                    
                    NFTVisual(
                        imageUrl: viewModel.imageUrl,
                        backgroundColor: viewModel.backgroundColor
                    )
                    .padding([.bottom], spacing)

                    ActionRow(
                        list: viewModel.actionButtons
                    )
                    .padding([.bottom], spacing)
                    
                    VStack(alignment: .leading) {
                        NFTHeader(
                            title: viewModel.nft?.title,
                            text: viewModel.nft?.collection?.title
                        )
                        .padding([.bottom], spacing)

                        if viewModel.nft?.text != nil {
                            NFTDescription(text: viewModel.nft!.text!)
                                .padding([.bottom], spacing)
                        }
                        
                        Divider().padding(.vertical)

                        if viewModel.creator != nil {
                            CreatorItem(item: viewModel.creator!)
                                .padding([.bottom], spacing)
                            Divider().padding(.vertical)
                        }
                        
                        if !viewModel.traits.isEmpty {
                            TraitGrid(list: viewModel.traits)
                                .padding([.bottom], spacing)
                            Divider().padding(.vertical)
                        }
                        
                        NFTDetails(
                            address: viewModel.nft?.address ?? "--",
                            tokenId: viewModel.nft?.tokenId ?? "--",
                            standard: viewModel.nft?.standard
                        )
                            .padding([.bottom], spacing)
                        
                
                        if(viewModel.nft?.externalURL != nil) {
                            HStack(alignment: .center) {
                                Spacer()
                                URLLink(
                                    url: viewModel.nft!.externalURL!,
                                    title: "metadata"
                                )
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            
            }
            
            SheetDismissButton(
                onTapFn: {
                    viewModel.dismiss()
                }
            )
        }
        .ignoresSafeArea()
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            viewModel.load(
                contractAddress: contractAddress,
                tokenId: tokenId
            )
        }
    }
}

struct NFTSheet_Previews: PreviewProvider {
    static var previews: some View {
        NFTSheet(
            contractAddress: TestData.nft.address,
            tokenId: TestData.nft.tokenId
        )
    }
}
