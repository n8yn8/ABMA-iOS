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
            setEnabled(isEnabled: false)
            
            if let thisSurvey = survey {
                titleTextField.stringValue = thisSurvey.title
                desciptionTextField.stringValue = thisSurvey.details
                urlTextField.stringValue = thisSurvey.url
                startDatePicker.dateValue = thisSurvey.start
                endDatePicker.dateValue = thisSurvey.end
                setEnabled(isEnabled: true)
            }
            
        }
    }
    weak var delegate: SurveyViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var desciptionTextField: NSTextField!
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var startDatePicker: NSDatePicker!
    @IBOutlet weak var endDatePicker: NSDatePicker!
    @IBOutlet weak var saveButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDatePicker.dateValue = Date()
        endDatePicker.dateValue = Date()
        
        setEnabled(isEnabled: survey != nil)
    }
    
    func setEnabled(isEnabled: Bool) {
        titleTextField.isEnabled = isEnabled
        desciptionTextField.isEnabled = isEnabled
        urlTextField.isEnabled = isEnabled
        startDatePicker.isEnabled = isEnabled
        endDatePicker.isEnabled = isEnabled
        saveButton.isEnabled = isEnabled
    }
    
    @IBAction func save(_ sender: Any) {
        let title = titleTextField.stringValue
        let desciption = desciptionTextField.stringValue
        let url = urlTextField.stringValue
        let start = startDatePicker.dateValue
        let end = endDatePicker.dateValue
        let thisSurvey = BSurvey()
        thisSurvey.initWith(title: title, details: desciption, url: url, start: start, end: end)
        delegate?.saveSurvey(survey: thisSurvey)
    }
    
}

protocol SurveyViewControllerDelegate: AnyObject {
    func saveSurvey(survey: BSurvey)
}
