//
//  WalletsSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import SwiftUI

struct WalletsSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: WalletsSheetViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: WalletsSheetViewModel())
        
        LayoutHelpers.stylePageTitle()
    }
    
    var body: some View {
        
        VStack {
            
            if viewModel.wallets.isEmpty {
                
                ViewPlaceholder()
                
            } else {
                
                List {
                    ForEach(viewModel.wallets) { item in
                        NavigationLink(
                            destination: ConnectSheet(address: item.address!)
                        ) {
                            WalletItem(item: item)
                        }
                        
                    }
                    .onDelete { offsets in
                        viewModel.delete(at: offsets)
                    }
                }.refreshable {
                    await viewModel.sync()
//                    try? await Task.sleep(nanoseconds: UInt64(4e+9))
                }
                
            }
        }
        .navigationTitle("Wallets")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    viewModel.dismiss()
                } label: {
                    Label("Dismiss", systemImage: "xmark")
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(.plain)
                
          })
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                NavigationLink(
                    destination: ConnectSheet()
                ) {
                    Image(systemName: "plus.rectangle")
                }
          })
        })
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct WalletsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WalletsSheet()
        }
    }
}
