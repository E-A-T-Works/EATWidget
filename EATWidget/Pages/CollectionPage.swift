//
//  CollectionPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/25/22.
//

import SwiftUI

struct CollectionPage: View {
    let address: String
    
    init(address: String) {
        self.address = address
        
        LayoutHelpers.stylePageTitle()
    }
    
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct CollectionPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionPage(address: "123")
        }
        
    }
}
