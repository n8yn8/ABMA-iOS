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
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    
    var image: NSImage!
    var imageData: Data!
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
        activityIndicator.startAnimation(self)
        let sponsorUrl = self.urlTextField.stringValue
        DbManager.sharedInstance.uploadSponsorImage(name: imageName, image: imageData) { (imageUrl, error) in
            if let err = error {
                print("error saving image: \(err.localizedDescription)")
                self.activityIndicator.stopAnimation(self)
                return
            }
            let sponsor = BSponsor()
            sponsor.url = sponsorUrl
            sponsor.imageUrl = imageUrl
            DbManager.sharedInstance.update(sponsor: sponsor, yearParent: self.yearParentId, callback: { (savedSponsor, error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimation(self)
                    if let saved = savedSponsor {
                        YearsModel.instance.add(sponsor: saved)
                        self.dismiss(nil)
                    }
                }
                
            })
            
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(nil)
    }
}
