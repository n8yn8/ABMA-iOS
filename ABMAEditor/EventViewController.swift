//
//  ViewController.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 1/2/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class EventViewController: NSViewController {

    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var startTimePicker: NSDatePicker!
    @IBOutlet weak var endTimePicker: NSDatePicker!
    @IBOutlet weak var locationTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var subtitleTextField: NSTextField!
    @IBOutlet weak var descriptionTextField: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.dateValue = Date()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func save(_ sender: NSButton) {
        print("date = \(datePicker.dateValue)")
        print("locaion = \(locationTextField.stringValue)")
    }

}

