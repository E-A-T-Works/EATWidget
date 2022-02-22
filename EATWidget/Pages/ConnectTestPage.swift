//
//  ConnectTestPage.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/22/22.
//

import SwiftUI
import WalletConnect

struct ConnectTestPage: View {

    
    
    
    var body: some View {
        VStack {
            Text("Connect Test")
            Button(action: {
                print("Clicked")
                
                let permissions = Session.Permissions(
                    blockchains: [
                        "eip155:1",
                        "eip155:137"
                    ],
                    methods: [
                        "personal_sign"
                    ],
                    notifications: []
                )
                
                do {
                    if let uri = try WalletConnectDelegate.shared.client.connect(
                        sessionPermissions: permissions
                    ) {
                        print("URI \(uri)")
                    }
                } catch {
                    print("[PROPOSER] Pairing connect error: \(error)")
                }
                
            }, label: {
                Text("Test")
            }).padding()
        }.onAppear {
            
            print("Connect Page onAppear")
            
            if let session = WalletConnectDelegate.shared.client.getSettledSessions().first {
                
                print("GOT IT \(session)")
                
            } else {
                print("DONT GOT IT")
            }
            
        }
        
    }
}

struct ConnectTestPage_Previews: PreviewProvider {
    static var previews: some View {
        ConnectTestPage()
    }
}
