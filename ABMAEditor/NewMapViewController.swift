//
//  NewMapViewController.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 3/31/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

import Cocoa

class NewMapViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    
    weak var delegate: NewMapViewControllerDelegate?
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
        titleTextField.stringValue = ""
    }
    
    @IBAction func save(_ sender: Any) {
        activityIndicator.startAnimation(self)
        DbManager.sharedInstance.uploadMapImage(name: imageName, image: imageData) { (imageUrl, error) in
            if let err = error {
                print("error saving image: \(err.localizedDescription)")
                self.activityIndicator.stopAnimation(self)
                return
            }
            let map = BMap()
            map.title = self.titleTextField.stringValue
            map.url = imageUrl
            self.activityIndicator.stopAnimation(self)
            self.delegate?.saveMap(map: map)
            self.dismiss(nil)
            
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(nil)
    }
}

protocol NewMapViewControllerDelegate: class {
    func saveMap(map: BMap)
}
