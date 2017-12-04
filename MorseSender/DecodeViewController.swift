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
    var lastAct : Date?
    var actDur = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let presser : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        presser.minimumPressDuration = 0.5
        presser.delegate = self
        presser.delaysTouchesBegan = true
        self.redBtn.addGestureRecognizer(presser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func decode(_ sender: UIButton) {
        lastAct = nil
        print(actDur)
    }
    @objc func longTap(_ sender: UILongPressGestureRecognizer) {
        print("Long tap")
        if sender.state == .ended {
            print("PressEnded")
            let last = lastAct
            lastAct = Date()
            let interval = lastAct!.timeIntervalSince(last!)
            if interval < 1.5{
                actDur.append(1)
            }else{
                actDur.append(3)
            }
        }
        else if sender.state == .began {
            print("PressBegan.")
            if let last = lastAct {
                lastAct = Date()
                let interval = lastAct?.timeIntervalSince(last)
                if interval! < 1.5{
                    actDur.append(1)
                }else{
                    actDur.append(3)
                }
            }else{//begins new message
                actDur.removeAll()
                lastAct = Date()
            }
            
        }
    }
        

}
