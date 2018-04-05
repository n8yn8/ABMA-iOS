//
//  SponsorItem.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa
import SDWebImage

class SponsorItem: NSCollectionViewItem {
    
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
    
    var sponsor: BSponsor? {
        didSet {
            guard isViewLoaded else { return }
            if let sponsor = sponsor {
                spinner.startAnimation(nil)
                let url = URL(string: sponsor.imageUrl!)
                imageView?.sd_setImage(with: url!, completed: { (image, error, cacheType, url) in
                    self.spinner.stopAnimation(nil)
                })
                if let clickUrl = sponsor.url {
                    textField?.stringValue = clickUrl
                } else {
                    textField?.stringValue = ""
                }
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        
        view.layer?.borderColor = NSColor.gray.cgColor
        view.layer?.borderWidth = 0.0
    }
    
}
