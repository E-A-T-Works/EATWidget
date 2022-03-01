//
//  WalletSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import SwiftUI

struct WalletSheet: View {
    
    let address: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel = WalletSheetViewModel()
    
    @FocusState private var titleIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section(header: Text("Wallet Info")) {
                    TextField(
                        "Nickname (Optional)",
                        text: .init(
                            get: { [viewModel] in viewModel.form.title },
                            set: { [viewModel] in viewModel.updateTitle($0) }
                        )
                    )
                        .focused($titleIsFocused)
                    
                    HStack {
                        Text(address.formattedWeb3)
                    }
                }
        
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

                    }
                    
                }
            }
        }
        .navigationTitle("Wallet")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(
                    "Done",
                    action: {
                        viewModel.submit()
                    }
                )
                    .disabled(
                        viewModel.loading || !viewModel.form.isValid
                    )
          })
        })
        .onAppear {
            viewModel.load(address: address)
        }
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

struct WalletSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WalletSheet(address: "0x000001212121")
        }
    }
}
