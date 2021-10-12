//
//  NewYearsViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class NewYearsViewController: NSViewController {

    @IBOutlet weak var yearTextField: NSTextField!
    @IBOutlet weak var yearStepper: NSStepper!
    var year = 2017 {
        didSet {
            if yearTextField != nil {
                updateYear()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        yearStepper.integerValue = year
        updateYear()
    }
    
    @IBAction func changed(_ sender: NSStepper) {
        year = yearStepper.integerValue
    }
    
    func updateYear() {
        yearTextField.stringValue = "\(year)"
    }
    
    @IBAction func done(_ sender: Any) {
        let yearsModel = YearsModel.instance
        for checkYear in yearsModel.yearsRelay.value {
            if checkYear.name == year {
                yearsModel.selectedYearRelay.accept(checkYear)
                dismiss(nil)
                return
            }
        }
        let thisYear = BYear()
        thisYear.name = year
        yearsModel.add(year: thisYear)
        dismiss(nil)
    }
    
}
