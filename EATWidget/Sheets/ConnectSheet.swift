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
    
    @StateObject private var viewModel = ConnectSheetViewModel(
        initialFormState: ConnectFormState(title: "", address: "")
    )
    
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
                        "Load NFTs",
                        action: {
                            addressIsFocused = false
                            titleIsFocused = false
                            
                            viewModel.load()
                        }
                    )
                }
                
                if viewModel.ready {
                    if viewModel.loading {
                        ViewLoader()
                    } else {
                        if !viewModel.unsupported.isEmpty {
                            Section(header: Text("NFTs")) {
                                ForEach(viewModel.supported) { item in
                                    NFTItem(item: item)
                                }
                            }
                        }
                        
                        if !viewModel.unsupported.isEmpty {
                            Section(header: Text("Unsupported")) {
                                ForEach(viewModel.unsupported) { item in
                                    UnsupportedNFTItem(item: item)
                                }
                            }
                        }
                        
                        Section {
                            HStack {
                                Text("Not seeing your NFTs?")
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.presentMailFormSheet()
                                }, label: {
                                    Text("Contact")
                                })
                            }
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
                ).disabled(!viewModel.canAddWallet)
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
                    print(result)
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
