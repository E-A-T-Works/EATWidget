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
                    
                    Button {
                        viewModel.sync()
                    } label: {
                        Text("Refresh NFTs")
                    }

                }
                
            }
        }
        .navigationTitle("Connected Wallets")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                
                Button(action: {
                    viewModel.dismiss()
                }, label: {
                    Text("DONE")
                        .font(.system(size: 16, design: .monospaced))
                })
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
