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
    var yearParentId: String!
    
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
        DbManager.sharedInstance.uploadImage(name: imageName, image: imageData) { (imageUrl, error) in
            if let err = error {
                print("error saving image: \(err.localizedDescription)")
                return
            }
            let sponsor = BSponsor()
            sponsor.url = self.urlTextField.stringValue
            sponsor.imageUrl = imageUrl
            DbManager.sharedInstance.update(sponsor: sponsor, yearParent: self.yearParentId, callback: { (savedSponsor, error) in
                if let saved = savedSponsor {
                    self.delegate?.saveSponsor(sponsor: saved)
                    self.dismiss(nil)
                }
            })
            
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(nil)
    }
}

protocol NewSponsorViewControllerDelegate: class {
    func saveSponsor(sponsor: BSponsor)
}
