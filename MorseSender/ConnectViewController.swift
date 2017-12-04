//
//  ConnectViewController.swift
//  MorseSender
//
//  Created by skuang on 10/31/17.
//  Copyright © 2017 Sharon Kuang. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, MPCManagerDelegate{
    
    @IBOutlet weak var myDev: UITextField!
    @IBOutlet weak var reScan: UIButton!
    @IBOutlet weak var togCon: UISwitch!
    @IBOutlet weak var devices: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.devices.delegate = self
        self.devices.dataSource = self
        self.myDev.delegate = self
        appDelegate.mpcManager.delegate = self
        togCon.isOn = false;
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        devices.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func scanning(_ sender: Any) {
        appDelegate.mpcManager.browser.stopBrowsingForPeers()
        appDelegate.mpcManager.browser.startBrowsingForPeers()
    }
    @IBAction func toggleConnection(_ sender: UISwitch) {
        if sender.isOn{
            appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        }else{
            appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
        }
    }
    //tableView stuff
    func foundPeer() {
        DispatchQueue.main.async { self.devices.reloadData() };
    }
    func lostPeer() {
        DispatchQueue.main.async { self.devices.reloadData() };
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        appDelegate.mpcManager.newPeer(newName: textField.text!)
        if togCon.isOn{
            appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        }else{
            appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
        }
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        return true
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(appDelegate.mpcManager.foundPeers.count)
        return appDelegate.mpcManager.foundPeers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DeviceTVCell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DeviceTVCell
        cell.devName.text = appDelegate.mpcManager.foundPeers[indexPath.row].displayName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = appDelegate.mpcManager.foundPeers[indexPath.row] as MCPeerID
        appDelegate.mpcManager.browser.invitePeer(selectedPeer, to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
    }
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        OperationQueue.main.addOperation { () -> Void in
            self.performSegue(withIdentifier: "chatPeer", sender: self)
        }
    }

}
