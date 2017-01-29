//
//  SponsorItem.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class SponsorItem: NSCollectionViewItem {
    
    var sponsor: Sponsor? {
        didSet {
            guard isViewLoaded else { return }
            if let sponsor = sponsor {
                imageView?.image = NSImage(named: "AppIcon-Mac")
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
