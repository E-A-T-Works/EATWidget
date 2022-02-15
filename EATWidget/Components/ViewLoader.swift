//
//  ViewLoader.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//

import SwiftUI

struct ViewLoader: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading...")
                .font(.caption)
                .opacity(0.72)
        }
    }
}

struct ViewLoader_Previews: PreviewProvider {
    static var previews: some View {
        ViewLoader()
    }
}
