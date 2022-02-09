//
//  AssetSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//

import SwiftUI

struct AssetSheet: View {
    
    let contractAddress: String
    let tokenId: String
    
    @StateObject private var viewModel = AssetSheetViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.asset?.backgroundColor != nil {
                Color((viewModel.asset?.backgroundColor!)!)
            }
            
            VStack(alignment: .leading) {
                AsyncImage(url: viewModel.asset?.imageUrl){ image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                
                Text("Loaded \(viewModel.asset?.title ?? "NOT LOADED YET")")
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.load(
                contractAddress: contractAddress,
                tokenId: tokenId
            )
        }
    }
}

struct AssetSheet_Previews: PreviewProvider {
    static var previews: some View {
        AssetSheet(
            contractAddress: TestData.asset.contract.address,
            tokenId: TestData.asset.tokenId
        )
    }
}
