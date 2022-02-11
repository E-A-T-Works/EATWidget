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
                    
                    ///
                    /// Image
                    ///
                    
                    CachedAsyncImage(url: viewModel.asset?.imageUrl){ image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(viewModel.backgroundColor)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding([.bottom], spacing)
                    
                    ///
                    /// Actions
                    ///
                    
                    VStack(alignment: .center) {
                        HStack {
                        
                            Link(
                                destination: (viewModel.asset?.permalink!)!,
                                label: {
                                    HStack{
                                        Image(uiImage: UIImage(named: "opensea")!).resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width:24)
                                        Text("OpenSea")
                                            .lineLimit(1)
                                    }
                                }
                            )
                                .buttonStyle(.bordered)
                                .padding(.horizontal, 6)
                            
                            Link(
                                destination: (viewModel.asset?.permalink!)!,
                                label: {
                                    HStack{
                                        Image(uiImage: UIImage(named: "etherscan")!).resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width:24)
                                        Text("Etherscan")
                                            .lineLimit(1)
                                    }
                                }
                            )
                                .buttonStyle(.bordered)
                                .padding(.horizontal, 6)
                               
                        }
                        

                    }
                    .padding([.bottom], spacing)
                    .padding(.horizontal)
                    
                    ///
                    /// Heading
                    ///
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.asset?.title ?? "Untitled")
                                .font(.title)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(uiImage: UIImage(named: "eth")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:12)
                            
                            Text("2.1")
                        }
                        
                    }
                    .padding([.bottom], spacing)
                    .padding(.horizontal)
                    
                    
                    ///
                    /// Author
                    ///
                    
                    // TODO:
                    
                    ///
                    /// Collection
                    ///
                    
                    // TODO:
                    
                    
                    ///
                    /// Description
                    ///
                    
                    if viewModel.asset?.text != nil {
                        HStack {
                            VStack(alignment: .leading) {
                                Text((viewModel.asset?.text!)!)
                                    .font(.body)
                            }
                        }
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
    static var previews: some View {
        AssetSheet(
            contractAddress: TestData.assets[0].contract.address,
            tokenId: TestData.assets[0].tokenId
        )
    }
}
