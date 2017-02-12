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
    
    var sponsor: Sponsor? {
        didSet {
            guard isViewLoaded else { return }
            if let sponsor = sponsor {
                spinner.startAnimation(nil)
                let url = URL(string: sponsor.imageUrl!)
                imageView?.sd_setImage(with: url!, completed: { (image, error, cacheType, url) in
                    self.spinner.stopAnimation(nil)
                })
                textField?.stringValue = sponsor.url!
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
}
