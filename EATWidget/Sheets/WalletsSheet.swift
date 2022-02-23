//
//  WalletsSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/23/22.
//

import SwiftUI

struct WalletsSheet: View {
    @StateObject private var viewModel = WalletsSheetViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.wallets) { item in
                WalletItem(item: item)
            }
            .onDelete { offsets in
                viewModel.delete(at: offsets)
            }
        }
        .navigationTitle("Connected Wallets")
    }
}

struct WalletsSheet_Previews: PreviewProvider {
    static var previews: some View {
        WalletsSheet()
    }
}
