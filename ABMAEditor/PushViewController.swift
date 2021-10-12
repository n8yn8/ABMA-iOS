//
//  PushViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 4/13/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class PushViewController: NSViewController {
    
    weak var delegate: PushViewControllerDelegate?

    @IBOutlet weak var messageTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func sendPush(_ sender: Any) {
        delegate?.sendUpdate(message: messageTextField.stringValue)
        dismiss(nil)
    }
}

protocol PushViewControllerDelegate: AnyObject {
    func sendUpdate(message: String)
}
