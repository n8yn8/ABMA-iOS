//
//  SponsorsViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class SponsorsViewController: NSViewController {
    
    private var sponsors = [BSponsor]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var yearParentId: String! {
        didSet {
            DbManager.sharedInstance.getSponsors(parentId: yearParentId) { (response, error) in
                guard let theseSponsors = response else {
                    return
                }
                self.sponsors = theseSponsors
            }
        }
    }

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var removeButton: NSButton!
    
    weak var delegate: SponsorsViewControllerDelegate?
    lazy var sheetViewController: NewSponsorViewController = {
        let vc = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "NewSponsorViewController"))
            as! NewSponsorViewController
        vc.yearParentId = yearParentId
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        
        view.wantsLayer = true
    }
    
    func updateSponsors(sponsorList: [BSponsor]?) {
        self.sponsors.removeAll()
        if let sponsors = sponsorList {
            self.sponsors.append(contentsOf: sponsors)
        }
        collectionView.reloadData()
    }
    
    @IBAction func add(_ sender: Any) {
        let fileDialog = NSOpenPanel()
        fileDialog.runModal()
        
        let path = fileDialog.url?.path
        let name = fileDialog.url?.lastPathComponent
        print("name = \(String(describing: name))")
        
        // Make sure that a path was chosen
        if let path = path {
            loadImageFromPath(name: name!, path: path)
        }
    }
    
    func loadImageFromPath(name: String, path: String) {
        
        let data = NSData(contentsOfFile: path)
        
        let image = NSImage(contentsOfFile: path)
        
        if let image = image  {
            print("Image exists")
            sheetViewController.image = image
            sheetViewController.imageData = data
            sheetViewController.imageName = name.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
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
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SponsorItem"), for: indexPath)
        guard let sponsorItem = item as? SponsorItem else {return item}
        
        sponsorItem.sponsor = sponsors[indexPath.item]
        
        return sponsorItem
    }
    
}

extension SponsorsViewController: NewSponsorViewControllerDelegate {
    func saveSponsor(sponsor: BSponsor) {
        delegate?.saveSponsor(savedSponsor: sponsor)
    }
}

protocol SponsorsViewControllerDelegate: class {
    func saveSponsor(savedSponsor: BSponsor)
}
