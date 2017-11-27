//
//  FirstViewController.swift
//  MorseSender
//
//  Created by Sharon Kuang on 10/20/17.
//  Copyright © 2017 Sharon Kuang. All rights reserved.
//

import UIKit
import AVFoundation
class TransmitViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var transmitBtn: UIButton!
    @IBOutlet weak var messageField: UITextField!
    var morseCode = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        messageLabel.text = textField.text
        DispatchQueue.main.async{
            self.turnToMorse(message: self.messageLabel.text!)
        }
        return true
    }
    func turnToMorse(message: String){
        morseCode.removeAll()
        for c in message{
            switch(c){
            case "a"://.-
                morseCode+=[1,1,3,3]
            case "b"://-...
                morseCode+=[3,1,1,1,1,1,1,3]
            case "c"://-.-.
                morseCode+=[3,1,1,1,3,1,1,3]
            case "d"://-..
                morseCode+=[3,1,1,1,1,3]
            case "e"://.
                morseCode+=[1,3]
            case "f"://..-.
                morseCode+=[1,1,1,1,3,1,1,3]
            case "g"://--.
                morseCode+=[3,1,3,1,1,3]
            case "h"://....
                morseCode+=[1,1,1,1,1,1,1,3]
            case "i"://..
                morseCode+=[1,1,1,3]
            case "j"://.---
                morseCode+=[1,1,3,1,3,1,3,3]
            case "k"://-.-
                morseCode+=[3,1,1,1,3,3]
            case "l"://.-..
                morseCode+=[1,1,3,1,1,1,1,3]
            case "m"://--
                morseCode+=[3,1,3,3]
            case "n"://-.
                morseCode+=[3,1,1,3]
            case "o"://---
                morseCode+=[3,1,3,1,3,3]
            case "p"://.--.
                morseCode+=[1,1,3,1,3,1,1,3]
            case "q"://--.-
                morseCode+=[3,1,3,1,1,1,3,3]
            case "r"://.-.
                morseCode+=[1,1,3,1,1,3]
            case "s"://...
                morseCode+=[1,1,1,1,1,3]
            case "t"://-
                morseCode+=[3,3]
            case "u"://..-
                morseCode+=[1,1,1,1,3,3]
            case "v"://...-
                morseCode+=[1,1,1,1,1,1,3,3]
            case "w"://.--
                morseCode+=[1,1,3,1,3,3]
            case "x"://-..-
                morseCode+=[3,1,1,1,1,1,3,3]
            case "y"://-.--
                morseCode+=[3,1,1,1,3,1,3,3]
            case "z"://--..
                morseCode+=[3,1,3,1,1,1,1,3]
            case "1"://.----
                morseCode+=[1,1,3,1,3,1,3,1,3,3]
            case "2"://..---
                morseCode+=[1,1,1,1,3,1,3,1,3,3]
            case "3"://...--
                morseCode+=[1,1,1,1,1,1,3,1,3,3]
            case "4"://....-
                morseCode+=[1,1,1,1,1,1,1,1,3,3]
            case "5"://.....
                morseCode+=[1,1,1,1,1,1,1,1,1,3]
            case "6"://-....
                morseCode+=[3,1,1,1,1,1,1,1,1,3]
            case "7"://--...
                morseCode+=[3,1,3,1,1,1,1,1,1,3]
            case "8"://---..
                morseCode+=[3,1,3,1,3,1,1,1,1,3]
            case "9"://----.
                morseCode+=[3,1,3,1,3,1,3,1,1,3]
            case "0"://-----
                morseCode+=[3,1,3,1,3,1,3,1,3,3]
            case " ":
                morseCode[morseCode.endIndex-1] = 7
            default:
                break
            }
        }
        print("translated\n")
        //morseCode.popLast()
    }
    @IBAction func transmit(_ sender: UIButton) {
        print("flashing1\n")
        let flash = AVCaptureDevice.default(for: .video)
        print("flashing2\n")
        if flash != nil {
            DispatchQueue.global(qos: .userInitiated).async{
                let flash1 = AVCaptureDevice.default(for: .video)
                for (index,duration) in self.morseCode.enumerated(){
                    if index%2 == 0{//light on
                        DispatchQueue.main.async{
                            flash1?.torchMode = .on
                        }
                        Thread.sleep(forTimeInterval: TimeInterval(duration))
                    }else{//light off
                        DispatchQueue.main.async{
                            flash1?.torchMode = .off
                        }
                        Thread.sleep(forTimeInterval: TimeInterval(duration))
                    }
                }
            }
        }else{
            print("no torch\n")
            DispatchQueue.global(qos: .userInitiated).async{
                for (index,duration) in self.morseCode.enumerated(){
                if index%2 == 0{//light on
                    DispatchQueue.main.async{
                        self.view.backgroundColor = UIColor.white
                        //print("white")
                    }
                    Thread.sleep(forTimeInterval: TimeInterval(duration))
                }else{//light off
                    DispatchQueue.main.async{
                        self.view.backgroundColor = UIColor.black
                        //print("black")
                    }
                    Thread.sleep(forTimeInterval: TimeInterval(duration))
                }
            }
            }}
    }

}

