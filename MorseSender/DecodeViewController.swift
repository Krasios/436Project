//
//  SecondViewController.swift
//  MorseSender
//
//  Created by Sharon Kuang on 10/20/17.
//  Copyright © 2017 Sharon Kuang. All rights reserved.
//

import UIKit

class DecodeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var decodeBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.redBtn.addGestureRecognizer(lpgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func longTap(_ sender: UILongPressGestureRecognizer) {
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
        }
    }
        

}
