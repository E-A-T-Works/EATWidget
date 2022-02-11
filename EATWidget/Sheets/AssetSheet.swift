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
                    
                    ///
                    /// Heading
                    ///
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.asset?.title ?? "Untitled")
                                .lineLimit(1)
                            
                            if viewModel.asset?.collection != nil {
                                Text(viewModel.asset?.collection!.title ?? "--")
                                    .lineLimit(1)
                            }
                            
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(uiImage: UIImage(named: "Eth")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:12)
                            
                            Text("2.1")
                        }
                        
                    }
                    .padding([.bottom], spacing)
                    .padding(.horizontal)
                    
                    ///
                    /// Description
                    ///
                    
                    if viewModel.asset?.text != nil {
                        HStack {
                            VStack(alignment: .leading) {
                                Text((viewModel.asset?.text!)!)
                                    .font(.system(.body, design: .monospaced))
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding()
                    }
                    
                    
                    ///
                    /// Author
                    ///
                    
                    if viewModel.asset?.creator != nil {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(viewModel.asset?.creator!.user?.username ?? "--").font(.system(.body, design: .monospaced))
                                
                                Text(viewModel.asset?.creator!.address ?? "--")

                            }
                            Spacer()
                        }
                        .padding([.bottom], spacing)
                        .padding(.horizontal)
                        
                        Divider()
                            .padding()
                    }


                    ///
                    /// Stats
                    ///
                    
                    VStack {
                        HStack {
                            Text("Contract Address")
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text((viewModel.asset?.contract.address)!)
                                .lineLimit(1)
                        }
                        
                        HStack {
                            Text("Token ID")
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text((viewModel.asset?.tokenId)!)
                                .lineLimit(1)
                        }
                        
                        HStack {
                            Text("Token Standard")
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text((viewModel.asset?.tokenId)!)
                                .lineLimit(1)
                        }
                    }
                    .padding([.bottom], spacing)
                    .padding(.horizontal)
                    
                    Divider()
                        .padding()
                    
                    ///
                    /// Metadata
                    ///
                    
                    VStack {
                        Link(
                            destination: (viewModel.asset?.permalink!)!,
                            label: {
                                HStack{
                                    Image(systemName: "link")
                                    Text("Metadata")
                                        .lineLimit(1)
                                }
                            }
                        )
                            .buttonStyle(.bordered)
                            .padding(.horizontal, 6)
                    }
                    
                    
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
