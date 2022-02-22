//
//  WalletConnectProvider.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/22/22.
//

import Foundation
import WalletConnect
import Relayer


final class WalletConnectDelegate: WalletConnectClientDelegate {
    var client: WalletConnectClient
    var onSessionSettled: ((Session)->())?
    var onSessionResponse: ((Response)->())?
    var onSessionDelete: (()->())?

    static var shared: WalletConnectDelegate = WalletConnectDelegate()
    
    private init() {
        let metadata = AppMetadata(
            name: "EATWidget",
            description: "See NFTs as widgets",
            url: "widget.eatworks.xyz",
            icons: ["https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media"]
        )
        let relayer = Relayer(
            relayHost: "relay.dev.walletconnect.com",
            projectId: "52af113ee0c1e1a20f4995730196c13e"
        )
        
        self.client = WalletConnectClient(metadata: metadata, relayer: relayer)
        client.delegate = self
    }
    
    func didSettle(session: Session) {
        print("didSettle \(session)")
        onSessionSettled?(session)
    }

    func didDelete(sessionTopic: String, reason: Reason) {
        print("didDelete \(sessionTopic), \(reason)")
        onSessionDelete?()
    }

    func didReceive(sessionResponse: Response) {
        print("didReceive \(sessionResponse)")
        onSessionResponse?(sessionResponse)
    }
    
    func didUpdate(sessionTopic: String, accounts: Set<Account>) {
        print("didUpdate \(sessionTopic) \(accounts)")
    }
    
    func didUpgrade(sessionTopic: String, permissions: Session.Permissions) {
        print("didUpgrade \(sessionTopic) \(permissions)")
    }
    
}
