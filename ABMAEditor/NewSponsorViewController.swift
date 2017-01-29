//
//  NewSponsorViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class NewSponsorViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var urlTextField: NSTextField!
    
    weak var delegate: NewSponsorViewControllerDelegate?
    var image: NSImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        imageView.image = image
    }
    
    @IBAction func save(_ sender: Any) {
        delegate?.saveSponsor(url: urlTextField.stringValue, image: image)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(nil)
    }
}

protocol NewSponsorViewControllerDelegate: class {
    func saveSponsor(url: String, image: NSImage)
}
