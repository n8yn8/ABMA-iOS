//
//  SponsorsViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class SponsorsViewController: NSViewController {
    
    var sponsors = [Sponsor]()

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var removeButton: NSButton!
    lazy var sheetViewController: NewSponsorViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "NewSponsorViewController")
            as! NewSponsorViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        for i in 0 ..< 30 {
            let sponsor = Sponsor()
            sponsor.url = "Some url \(i)"
            sponsors.append(sponsor)
        }
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = EdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        
        view.wantsLayer = true
    }
    
    @IBAction func add(_ sender: Any) {
        let fileDialog = NSOpenPanel()
        fileDialog.runModal()
        
        let path = fileDialog.url?.path
        
        // Make sure that a path was chosen
        if let path = path {
            loadImageFromPath(path: path)
        }
    }
    
    func loadImageFromPath(path: String) {
        
        let image = NSImage(contentsOfFile: path)
        
        if let image = image  {
            print("Image exists")
            sheetViewController.image = image
            sheetViewController.delegate = self
            presentViewControllerAsSheet(sheetViewController)
        } else {
            print("missing image at: \(path)")
        }
        
    }
    
    @IBAction func remove(_ sender: Any) {
    }
    
}

extension SponsorsViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsors.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "SponsorItem", for: indexPath)
        guard let sponsorItem = item as? SponsorItem else {return item}
        
        sponsorItem.sponsor = sponsors[indexPath.item]
        
        return sponsorItem
    }
    
}

extension SponsorsViewController: NewSponsorViewControllerDelegate {
    func saveSponsor(url: String, image: NSImage) {
        let sponsor = Sponsor()
        sponsor.url = url
        
    }
}
