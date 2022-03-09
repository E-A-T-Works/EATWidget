//
//  ConnectSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct ConnectSheet: View {
    // MARK: - Dependencies
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel = ConnectSheetViewModel()
    
    @FocusState private var titleIsFocused: Bool
    
    // MARK: - View Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section {
                    TextField(
                        "Nickname (Optional)",
                        text: .init(
                            get: { [viewModel] in viewModel.form.title },
                            set: { [viewModel] in viewModel.updateTitle($0) }
                        )
                    )
                        .focused($titleIsFocused)
                    
                    if !viewModel.form.address.isEmpty {
                        HStack {
                            Text(viewModel.form.address.formattedWeb3)
                            Spacer()
                            Button {
                                viewModel.resetAddress()
                            } label: {
                                Text("Try another")
                            }
                        }
                    } else {
                        Button(
                            "Paste Wallet Address",
                            action: {
                                let pasteboard = UIPasteboard.general
                                let address = pasteboard.string ?? ""

                                 if !viewModel.validateAddress(address) {
                                     viewModel.showingError.toggle()
                                     return
                                }

                                titleIsFocused = false

                                viewModel.updateAddress(address)
                                viewModel.lookup()
                            }
                        )
                        .alert(
                            isPresented: $viewModel.showingError
                        ) {
                            Alert(
                                title: Text("Invalid address"),
                                message: Text("Please paste a valid etherium wallet address to continue."),
                                dismissButton: .default(
                                    Text("Ok")
                                )
                            )
                        }
                    }
                } header: {
                    Text("Wallet Info")
                } footer: {
                    HStack{
                        Text("You can find your Etherium wallet address from [Metamask](https://metamask.app.link), [Trust](https://link.trustwallet.com), [Rainbow](https://rnbwapp.com), or whatever you use to manage your wallet." )

                    }
                    
                }

                if viewModel.ready {
                    if viewModel.loading {
                        HStack {
                            Spacer()
                            
                            ViewLoader()
                                .padding()
                            
                            Spacer()
                        }
                    } else {
                        
                        if !viewModel.supported.isEmpty {
                            Section {
                                ForEach(viewModel.supported) { item in
                                    NFTItem(item: item)
                                }
                            } header: {
                                Text("Supported NFTs")
                            } footer: {
                                Button(action: {
                                    viewModel.presentMailFormSheet()
                                }, label: {
                                    Text("Not seeing your NFT?")
                                })
                            }
                        } else {
                            VStack {
                            
                                ViewPlaceholder(
                                    text: "Sorry, we don't support these yet..."
                                )
                                
                                Button(action: {
                                    viewModel.presentMailFormSheet()
                                }, label: {
                                    Text("Let us know more")
                                })
                                
                            }
                            .padding()
                            
                            
                        }
                    }
                }
            }
        }
        .navigationTitle("Connect")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(
                    "Done",
                    action: {
                        viewModel.submit()
                    }
                ).disabled(
                    viewModel.loading || !viewModel.form.isValid || viewModel.supported.isEmpty
                )
          })
        })
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .sheet(isPresented: $viewModel.showingSheet) {
            switch viewModel.sheetContent {
            case .MailForm(let data):
                MailView(data: data) { result in
                    print()
                }
            }
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
