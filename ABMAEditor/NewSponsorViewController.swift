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
    var imageData: NSData!
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        imageView.image = image
        urlTextField.stringValue = ""
    }
    
    @IBAction func save(_ sender: Any) {
        DbManager.sharedInstance.uploadImage(name: imageName, image: imageData) { (url) in
            let sponsor = BSponsor()
            sponsor.url = self.urlTextField.stringValue
            sponsor.imageUrl = url
            self.delegate?.saveSponsor(sponsor: sponsor)
            self.dismiss(nil)
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(nil)
    }
}

protocol NewSponsorViewControllerDelegate: class {
    func saveSponsor(sponsor: BSponsor)
}
