//
//  SheetDismissButton.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/11/22.
//

import SwiftUI

struct SheetDismissButton: View {
    var onTapFn: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(
                    action: {
                        self.onTapFn()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            
                    }
                )
                .buttonStyle(.bordered)
                .frame(width: 30, height: 30)
                .cornerRadius(48)
                .padding()
            }

            Spacer()
        }
        
    }
}

struct SheetDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        SheetDismissButton(
            onTapFn: { () in }
        )
    }
}
