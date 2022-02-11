//
//  AssetSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct AssetSheet: View {
    
    let contractAddress: String
    let tokenId: String
    
    let spacing: CGFloat = 12
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel = AssetSheetViewModel()
    
    var body: some View {
        ZStack {

            if viewModel.loading {
                VStack {
                    ProgressView()
                        .padding(4)
                    Text("Loading...").opacity(0.72)
                }
            } else {
                ScrollView {
                    
                    AssetSheetVisual(
                        imageUrl: viewModel.imageUrl,
                        backgroundColor: viewModel.backgroundColor
                    )
                    .padding([.bottom], spacing)

                    AssetSheetActions(
                        list: viewModel.actionButtons
                    )
                    .padding([.bottom], spacing)

                    
                    VStack(alignment: .leading) {
                        AssetSheetHeader(
                            assetTitle: viewModel.asset?.title,
                            collectionTitle: viewModel.asset?.collection?.title
                        )
                        .padding([.bottom], spacing)

                        if viewModel.asset?.text != nil {
                            AssetSheetDescription(
                                text: (viewModel.asset?.text!)!
                            )
                            .padding([.bottom], spacing)
                        }
                        
                        Divider().padding(.vertical)
                        
                        if viewModel.creator != nil {
                            Text("Author TODO")
                                .padding([.bottom], spacing)
                            
                            Divider().padding(.vertical)
                        }


                        AssetSheetDetails(
                            contractAddress: viewModel.contract?.address ?? "--",
                            tokenId: viewModel.asset?.tokenId  ?? "--",
                            tokenStandard: viewModel.contract?.schemaName
                        )
                        .padding([.bottom], spacing)
                        
                
                        if(viewModel.asset?.tokenMetadata != nil) {
                            HStack(alignment: .center) {
                                Spacer()
                                URLLink(
                                    url: (viewModel.asset?.tokenMetadata!)!,
                                    title: "Metadata"
                                )
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                        
                    }
                    .padding(.horizontal)
                }
            
            }

            VStack {
                HStack {
                    Spacer()
                    
                    Button(
                        action: {
                            viewModel.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                
                        }
                    )
                    .buttonStyle(.bordered)
                    .frame(width: 30, height: 30)
                    .cornerRadius(48)
                    .padding()
                }
   
                Spacer()
            }
            
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

struct AssetSheet_Previews: PreviewProvider {
    static let asset = TestData.assets[1]
    
    static var previews: some View {
        AssetSheet(
            contractAddress: asset.contract.address,
            tokenId: asset.tokenId
        )
    }
}
