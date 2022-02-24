//
//  WalletsSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import SwiftUI

struct WalletsSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel = WalletsSheetViewModel()
    
    var body: some View {
        
        VStack {
            
            if viewModel.wallets.isEmpty {
                
                ViewPlaceholder()
                
            } else {
                
                List {
                    ForEach(viewModel.wallets) { item in
                        NavigationLink(
                            destination: WalletSheet(address: item.address!)
                        ) {
                            WalletItem(item: item)
                        }
                        
                    }
                    .onDelete { offsets in
                        viewModel.delete(at: offsets)
                    }
                }
                
            }
        }
        .navigationTitle("Connected Wallets")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(
                    "Done",
                    action: {
                        viewModel.dismiss()
                    }
                )
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
