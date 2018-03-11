//
//  SurveyViewController.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 3/7/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

import Cocoa

class SurveyViewController: NSViewController {
    
    var survey: BSurvey? {
        didSet {
            titleTextField.stringValue = ""
            desciptionTextField.stringValue = ""
            urlTextField.stringValue = ""
            startDatePicker.dateValue = Date()
            endDatePicker.dateValue = Date()
            
            if let thisSurvey = survey {
                titleTextField.stringValue = thisSurvey.title
                desciptionTextField.stringValue = thisSurvey.details
                urlTextField.stringValue = thisSurvey.url
                startDatePicker.dateValue = thisSurvey.start
                endDatePicker.dateValue = thisSurvey.end
            }
            
        }
    }
    
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var desciptionTextField: NSTextField!
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var startDatePicker: NSDatePicker!
    @IBOutlet weak var endDatePicker: NSDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
