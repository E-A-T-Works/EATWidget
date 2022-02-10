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
                
                Button(
                    "Preview NFTs",
                    action: {
                        addressIsFocused = false
                        titleIsFocused = false
                        
                        viewModel.load()
                    }
                ).disabled(!viewModel.form.isValid)

                if !viewModel.assets.isEmpty {
                    Section(header: Text("Preview")) {
                        ForEach(viewModel.assets) { asset in
                            AssetItem(item: asset)
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
    }
}

struct ConnectSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConnectSheet()
        }
        
    }
}
