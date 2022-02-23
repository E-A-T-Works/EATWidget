//
//  NFTSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct NFTSheet: View {
    
    let address: String
    let tokenId: String
    
    let spacing: CGFloat = 12
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = NFTSheetViewModel()
    
    var body: some View {
        GeometryReader { geo in
        ZStack {
            if viewModel.loading {
                ViewLoader()
            } else {
                
                if viewModel.error {
                    Text("Something went wrong...")
                } else {
                
                    ScrollView {
                        
                        NFTVisual(
                            image: UIImage(data: viewModel.nft!.image!.blob!)!,
                            animationUrl: viewModel.nft?.animationUrl
                        )
                        .frame(width: geo.size.width, height: geo.size.width)
                        .padding([.bottom], spacing)
                        
                        ActionRow(
                            list: viewModel.actionButtons
                        )
                        .padding([.bottom], spacing)
                        
                        VStack(alignment: .leading) {
                            NFTHeader(
                                title: viewModel.nft?.title,
                                text: nil
                            )
                            .padding([.bottom], spacing)

                            if viewModel.nft?.text != nil {
                                NFTDescription(text: viewModel.nft!.text!)
                                    .padding([.bottom], spacing)
                            }
                            
                            Divider().padding(.vertical)

                            
    //                        if (viewModel.nft?.attributes ?? []).count > 0 {
    //                            TraitGrid(list: viewModel.nft?.attributes!)
    //                                .padding([.bottom], spacing)
    //                            Divider().padding(.vertical)
    //                        }
                            
                            NFTDetails(
                                address: viewModel.nft?.address ?? "--",
                                tokenId: viewModel.nft?.tokenId ?? "--",
                                standard: viewModel.nft?.standard
                            )
                                .padding([.bottom], spacing)
                            
                    
                            if(viewModel.nft?.metadataUrl != nil) {
                                HStack(alignment: .center) {
                                    Spacer()
                                    URLLink(
                                        url: viewModel.nft!.metadataUrl!,
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
            }
            
            SheetDismissButton(
                onTapFn: {
                    viewModel.dismiss()
                }
            )
        }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.load(address: address, tokenId: tokenId)
        }
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NFTSheet_Previews: PreviewProvider {
    static var previews: some View {
        NFTSheet(
            address: TestData.nft.address,
            tokenId: TestData.nft.tokenId
        )
    }
}
