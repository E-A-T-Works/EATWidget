//
//  ConnectSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct ConnectSheet: View {
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    @State private var seed: Int = Int.random(in: 1..<7)
    
    @StateObject private var viewModel: ConnectSheetViewModel
    
    
    // MARK: - Initialization
    
    init(address: String? = nil) {
        self._viewModel = StateObject(wrappedValue: ConnectSheetViewModel(address: address))
        
        LayoutHelpers.stylePageTitle()
    }
    
    // MARK: - View Content

    var body: some View {
        
        ZStack {
                    
            Form {
                Section {
                    HStack {
                        TextField(
                            "ENS or Wallet Address",
                            text: .init(
                                get: { [viewModel] in viewModel.form.address },
                                set: { [viewModel] in viewModel.updateAddress($0) }
                            )
                        )
                        .disabled(viewModel.isAddressSet)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .submitLabel(.next)
                        .onSubmit { Task { await viewModel.lookupAndParse() } }
                        
                        Spacer()
                        
                        if viewModel.form.address.isEmpty {
                            Button {
                                print("paste")
                                viewModel.setAddressFromPasteboard()
                            } label: {
                                Image(systemName: "doc.on.clipboard")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                            .disabled(!UIPasteboard.general.hasStrings)
                        } else {
                            Button {
                                viewModel.reset()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                    
                } footer: {
                    if !viewModel.isAddressSet {
                        HStack(alignment: .top) {
                            Image(systemName: "info.circle")
                            
                            Text("You can find your Ethereum wallet address from [Metamask](https://metamask.app.link), [Trust](https://link.trustwallet.com), [Rainbow](https://rnbwapp.com), or whatever you use to manage your wallet." )
    
                        }
                    }
                }
                
                if viewModel.isAddressSet {
                    
                    Section {
                        TextField(
                            "Nickname (Optional)",
                            text: .init(
                                get: { [viewModel] in viewModel.form.title },
                                set: { [viewModel] in viewModel.updateTitle($0) }
                            )
                        )
                        .submitLabel(.done)
                    }
                    
                    if viewModel.isLoading {
                        
                        ViewLoader(seed: 2)
                            .padding(.vertical)
                        
                    } else {
                        
                        if viewModel.list.isEmpty {
                            
                            Text("Sorry, we could not find anything associated with this address. Currently we only support Ethereum addresses.")
                            
                        } else {
                         
                            Section {
                                ForEach(viewModel.list.indices, id: \.self) { i in
                                    
                                    NFTParseTaskItem(item: viewModel.list[i])
                                    
                                }
                            } header: {
                                
                                if viewModel.isParsing {
                                    HStack {
                                        Text("Importing \(viewModel.parsedCount) out of \(viewModel.totalCount)")
                                        
                                        Spacer()
                                    
                                        ProgressView()
                                    }

                                } else {
                                    Text("\(viewModel.successCount) out of  \(viewModel.totalCount) Supported")
                                }
                                
                            } footer: {
                                HStack {
                                    Text("Still not seeing your NFTs?")
                                    
                                    Link(
                                        destination: URL(string: "https://discord.gg/tmaddD9C")!
                                    ) {
                                        HStack {
                                            Text("Let us know on Discord")
                                            Image(systemName: "arrow.up.right")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
           
            if viewModel.showingLoader {
                OverlaySpinner()
            }
            
        }
        .navigationTitle("Connect a wallet")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button{
                    
                    if viewModel.isAddressSet {
                        Task { await viewModel.submit() }
                    } else {
                        Task { await viewModel.lookupAndParse() }
                    }
                    
                } label: {
                    
                    if viewModel.isAddressSet {
                        Text("DONE")
                            .font(.system(size: 16, design: .monospaced))
                    } else {
                        Text("IMPORT")
                            .font(.system(size: 16, design: .monospaced))
                    }

                }
                .disabled(
                    viewModel.isAddressSet ? viewModel.isLoading || viewModel.isParsing || viewModel.list.isEmpty : !viewModel.form.isValid
                )

          })
        })
        .alert(
            isPresented: $viewModel.showingError
        ) {
            Alert(
                title: Text("Invalid address"),
                message: Text("Please paste a valid Ethereum wallet address to continue."),
                dismissButton: .default(
                    Text("Ok")
                )
            )
        }
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in   
            guard shouldDismiss else { return }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ConnectSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConnectSheet()
        }
        
    }
}
