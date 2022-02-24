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
                        "Address",
                        text: $viewModel.form.address
                    ).disabled(true)
                    
                    TextField(
                        "Nickname (Optional)",
                        text: .init(
                            get: { [viewModel] in viewModel.form.title },
                            set: { [viewModel] in viewModel.updateTitle($0) }
                        )
                    )
                        .focused($titleIsFocused)
                }
                
                if viewModel.loadingNFTs {
                    HStack {
                        Spacer()
                        
                        ViewLoader()
                            .padding()
                        
                        Spacer()
                    }
                } else {
                    
                    if !viewModel.supported.isEmpty {
                        Section(header: Text("NFTs")) {
                            ForEach(viewModel.supported) { item in
                                NFTItem(item: item)
                            }.onDelete { offsets in
                                viewModel.delete(at: offsets)
                            }
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
                        viewModel.loading || viewModel.loadingNFTs || !viewModel.form.isValid
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
    }
}

struct WalletSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WalletSheet(address: "0x000001212121")
        }
    }
}
