//
//  AssetPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import SwiftUI

struct AssetPage: View {
    let contractAddress: String
    let tokenId: String
    
    @StateObject private var viewModel = AssetPageViewModel()

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

struct AssetPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AssetPage(
                contractAddress: TestData.asset.contract.address,
                tokenId: TestData.asset.tokenId
            )
        }
    }
}
