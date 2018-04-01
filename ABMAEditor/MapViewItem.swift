//
//  MapViewItem.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 3/31/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

import Cocoa
import SDWebImage

class MapViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
    
    var map: BMap? {
        didSet {
            guard isViewLoaded else { return }
            if let map = map {
                spinner.startAnimation(nil)
                let url = URL(string: map.url!)
                imageView?.sd_setImage(with: url!, completed: { (image, error, cacheType, url) in
                    self.spinner.stopAnimation(nil)
                })
                textField?.stringValue = map.title
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
