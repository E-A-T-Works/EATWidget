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
    
    @StateObject private var viewModel: ConnectSheetViewModel
    
    // MARK: - Initialization
    
    init() {
        self._viewModel = StateObject(wrappedValue: ConnectSheetViewModel())
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont.monospacedSystemFont(ofSize: 28.0, weight: .bold)
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont.monospacedSystemFont(ofSize: 16.0, weight: .bold)
        ]
    }
    
    // MARK: - View Content

    var body: some View {
        
        ZStack {
            VStack {
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
                            
                            Spacer()
                            
                            if viewModel.form.address.isEmpty {
                                Button {
                                    print("paste")
                                    viewModel.setAddressFromPasteboard()
                                } label: {
                                    Image(systemName: "doc.on.clipboard")
                                        .foregroundColor(.black)
                                }
                                .disabled(!UIPasteboard.general.hasStrings)
                            } else {
                                Button {
                                    print("reset")
                                    viewModel.reset()
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.black)
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
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                Text("loading...")
                                Spacer()
                            }
                        } else {
                        
                            Section {
                                ForEach(viewModel.list.indices, id: \.self) { i in
                                    NFTParseTaskItem(item: viewModel.list[i])
                                }
                            } header: {
                                
                                if viewModel.isProcessing {
                                    Text("\(viewModel.parsedCount) out of \(viewModel.totalCount) Processed")
                                } else {
                                    Text("\(viewModel.successCount) Pass / \(viewModel.failureCount) Fail")
                                }
                                
                            } footer: {
                                Text("Email us")
                            }
                            
                        }
                    }
                }
            }
        }
        .navigationTitle("Connect a wallet")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button{
                    
                    if viewModel.isAddressSet {
                        viewModel.submit()
                    } else {
                        Task { await viewModel.lookup() }
                    }
                    
                } label: {
                    
                    if viewModel.isAddressSet {
                        Text("DONE")
                            .font(.system(size: 16, design: .monospaced))
                    } else {
                        Text("CONNECT")
                            .font(.system(size: 16, design: .monospaced))
                    }

                }
                .disabled(
                    viewModel.isAddressSet ? viewModel.isLoading || viewModel.isProcessing : !viewModel.form.isValid
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
