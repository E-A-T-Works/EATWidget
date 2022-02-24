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
    @FocusState private var addressIsFocused: Bool
    
    // MARK: - View Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section(header: Text("Wallet Info")) {
                    TextField(
                        "Address",
                        text: .init(
                            get: { [viewModel] in viewModel.form.address },
                            set: { [viewModel] in viewModel.updateAddress($0) }
                        )
                    )
                        .focused($addressIsFocused)
                    
                    TextField(
                        "Nickname (Optional)",
                        text: .init(
                            get: { [viewModel] in viewModel.form.title },
                            set: { [viewModel] in viewModel.updateTitle($0) }
                        )
                    )
                        .focused($titleIsFocused)
                }
                
                Section {
                    Button(
                        "Lookup NFTs",
                        action: {
                            addressIsFocused = false
                            titleIsFocused = false
                            
                            viewModel.lookup()
                        }
                    )
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
                            Section(header: Text("NFTs")) {
                                ForEach(viewModel.supported) { item in
                                    NFTItem(item: item)
                                }.onDelete { offsets in
                                    viewModel.delete(at: offsets)
                                }
                            }
                        }
                        
                        Section {
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
