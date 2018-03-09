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
            
        }
    }
    
    @IBOutlet weak var surveyTitleTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var startDatePicker: NSDatePicker!
    @IBOutlet weak var endDatePicker: NSDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
