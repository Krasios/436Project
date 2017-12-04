//
//  MPCManager.swift
//  MorseSender
//
//  Created by skariyadan on 11/23/17.
//  Copyright © 2017 Sharon Kuang. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate{
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession?)->Void)!
    var delegate: MPCManagerDelegate?
    override init() {
        super.init()
        peer = MCPeerID(displayName: "morsesender")// UIDevice.current.name)
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "morsedecoder")
        advertiser.delegate = self
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "morsedecoder")
        browser.delegate = self
    }
    func newPeer(newName: String){
        session.disconnect()
        peer = MCPeerID(displayName: newName)
        session = MCSession(peer: peer)
        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "morsedecoder")
        advertiser.delegate = self
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "morsedecoder")
        browser.delegate = self
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        print("found: \(foundPeers)")
        delegate?.foundPeer()
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        delegate?.lostPeer()
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        self.invitationHandler = invitationHandler
        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            delegate?.connectedWithPeer(peerID: peerID)
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
        default:
            print("Did not connect to session: \(session)")
        }
    }
    func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
        do{
            try session.send(dataToSend, toPeers: peersArray as! [MCPeerID], with: MCSessionSendDataMode.reliable)
        }catch{
            return false
        }
        return true
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dictionary: [String: AnyObject] = ["data": data as AnyObject, "fromPeer": peerID]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: dictionary)
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
}
protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
}
