//
//  SecondViewController.swift
//  MorseSender
//
//  Created by Sharon Kuang on 10/20/17.
//  Copyright © 2017 Sharon Kuang. All rights reserved.
//

import UIKit

class DecodeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var decoded: UILabel!
    @IBOutlet weak var decodeBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    var lastAct : Date?
    var actDur = [Int]()
    var root = BinTreeNode(val: nil)
    var current : BinTreeNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let presser : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        presser.minimumPressDuration = 0.5
        presser.delegate = self
        presser.delaysTouchesBegan = true
        self.redBtn.addGestureRecognizer(presser)
        lastAct = nil
        actDur.removeAll()
        current = root
        self.setUpBinTree()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpBinTree(){
        DispatchQueue.global(qos: .userInitiated).async{
            self.root.lC = BinTreeNode(val: "E")//.
            self.root.lC?.lC = BinTreeNode(val: "I")//..
            self.root.lC?.rC = BinTreeNode(val: "A")//.-
            self.root.lC?.lC?.lC = BinTreeNode(val: "S")//...
            self.root.lC?.lC?.rC = BinTreeNode(val: "U")//..-
            self.root.lC?.rC?.lC = BinTreeNode(val: "R")//.-.
            self.root.lC?.rC?.rC = BinTreeNode(val: "W")//.--
            self.root.lC?.lC?.lC?.lC = BinTreeNode(val: "H")//....
            self.root.lC?.lC?.lC?.rC = BinTreeNode(val: "V")//...-
            self.root.lC?.lC?.rC?.lC = BinTreeNode(val: "F")//..-.
            self.root.lC?.lC?.rC?.rC = BinTreeNode(val: nil)//..--
            self.root.lC?.rC?.lC?.lC = BinTreeNode(val: "L")//.-..
            self.root.lC?.rC?.lC?.rC = BinTreeNode(val: nil)//.-.-
            self.root.lC?.rC?.rC?.lC = BinTreeNode(val: "P")//.--.
            self.root.lC?.rC?.rC?.rC = BinTreeNode(val: "J")//.---
            self.root.lC?.lC?.lC?.lC?.lC = BinTreeNode(val: "5")//.....
            self.root.lC?.lC?.lC?.lC?.rC = BinTreeNode(val: "4")//....-
            self.root.lC?.lC?.lC?.rC?.rC = BinTreeNode(val: "3")//...--
            self.root.lC?.lC?.rC?.rC?.rC = BinTreeNode(val: "2")//..---
            self.root.lC?.rC?.rC?.rC?.rC = BinTreeNode(val: "1")//.----
            self.root.rC = BinTreeNode(val: "T")//-
            self.root.rC?.lC = BinTreeNode(val: "N")//-.
            self.root.rC?.rC = BinTreeNode(val: "M")//--
            self.root.rC?.lC?.lC = BinTreeNode(val: "D")//-..
            self.root.rC?.lC?.rC = BinTreeNode(val: "K")//-.-
            self.root.rC?.rC?.lC = BinTreeNode(val: "G")//--.
            self.root.rC?.rC?.rC = BinTreeNode(val: "O")//---
            self.root.rC?.lC?.lC?.lC = BinTreeNode(val: "B")//-...
            self.root.rC?.lC?.lC?.rC = BinTreeNode(val: "X")//-..-
            self.root.rC?.lC?.rC?.lC = BinTreeNode(val: "C")//-.-.
            self.root.rC?.lC?.rC?.rC = BinTreeNode(val: "Y")//-.--
            self.root.rC?.rC?.lC?.lC = BinTreeNode(val: "Z")//--..
            self.root.rC?.rC?.lC?.rC = BinTreeNode(val: "Q")//--.-
            self.root.rC?.rC?.rC?.lC = BinTreeNode(val: nil)//---.
            self.root.rC?.rC?.rC?.rC = BinTreeNode(val: nil)//----
            self.root.rC?.lC?.lC?.lC?.lC = BinTreeNode(val: "6")//-....
            self.root.rC?.rC?.lC?.lC?.lC = BinTreeNode(val: "7")//--...
            self.root.rC?.rC?.rC?.lC?.lC = BinTreeNode(val: "8")//---..
            self.root.rC?.rC?.rC?.rC?.lC = BinTreeNode(val: "9")//----.
            self.root.rC?.rC?.rC?.rC?.rC = BinTreeNode(val: "0")//-----
        }
    }
    @IBAction func clear(_ sender: UIButton) {
        actDur.removeAll()
        lastAct = nil
    }
    @IBAction func decode(_ sender: UIButton) {
        lastAct = nil
        print(actDur)
        current = root
        var message = ""
        for (index, dur) in actDur.enumerated(){
            if index%2 == 0{
                if dur == 1 {
                    current = current!.lC
                }else {
                    current = current!.rC
                }
            }else{
                if dur == 7 {
                    message.append(" ")
                }else if dur == 3{
                    message.append(current!.value!)
                    current = root
                }
            }
        }
        message.append(current!.value!)
        DispatchQueue.main.async {
            self.decoded.text = message
        }
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
                }else if interval! > 5{
                    actDur.append(7)
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
