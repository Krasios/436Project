//
//  ConnectViewController.swift
//  MorseSender
//
//  Created by skariyadan on 10/31/17.
//  Copyright © 2017 Sharon Kuang. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var nearby = [String]()
    @IBOutlet weak var devices: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        devices.delegate = self
        devices.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableView stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearby.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Device"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        //let thisStand = tacoStands[indexPath.row]
        
        // Configure the cell...
        //cell?.nameLabel.text = thisStand.title
        //cell?.cityLabel.text = thisStand.city
        //cell?.specialityLabel.text = thisStand.subtitle
        
        return cell
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
