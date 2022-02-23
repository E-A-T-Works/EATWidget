//
//  FeedbackPrompt.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/22/22.
//

import SwiftUI

struct FeedbackPrompt: View {
    @Environment(\.colorScheme) var colorScheme
    
    let title: String?
    let action: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    action()
                }, label: {
                    Text(title ?? "Feedback")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .padding(8)
                })
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .shadow(radius: 2)
                    .padding()
                    
            }
        }
    }
}

struct FeedbackPrompt_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FeedbackPrompt(
                title: "Feedback",
                action: {}
            )
        }
    }
}
