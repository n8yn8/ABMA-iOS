//
//  NewYearsViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class NewYearsViewController: NSViewController {
    
    weak var delegate: NewYearsViewControllerDelegate?

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
        delegate?.yearCreated(year: year)
        dismiss(nil)
    }
    
}

protocol NewYearsViewControllerDelegate: class {
    func yearCreated(year: Int)
}
