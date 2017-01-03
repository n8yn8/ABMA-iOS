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
    @IBOutlet var descriptionTextView: NSTextView!
    
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.dateValue = Date()
        datePicker.calendar = self.calendar

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func save(_ sender: NSButton) {
        
        let startDate = buildDate(timePart: startTimePicker.dateValue)
        print("date = \(startDate)")
        
        let endDate = buildDate(timePart: endTimePicker.dateValue)
        print("endDate = \(endDate)")
        
        print("locaion = \(locationTextField.stringValue)")
        print("title = \(titleTextField.stringValue)")
        print("subtitle = \(subtitleTextField.stringValue)")
        print("description = \(descriptionTextView.string)")
    }
    
    func buildDate(timePart: Date) -> Date {
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timePart)
        let date = calendar.startOfDay(for: datePicker.dateValue)
        let finalDate = calendar.date(byAdding: timeComponents, to: date)!
        return finalDate
    }

}

