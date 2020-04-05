//
//  SponsorsViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class SponsorsViewController: NSViewController {
    
    private let disposeBag = DisposeBag()
    
    private var sponsors = [BSponsor]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var yearParentId: String!
    private var selectedSponsorIndex: Int?

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var removeButton: NSButton!
    
    lazy var sheetViewController: NewSponsorViewController = {
        let vc = self.storyboard!.instantiateController(withIdentifier: "NewSponsorViewController")
            as! NewSponsorViewController
        vc.yearParentId = yearParentId
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        configureCollectionView()
        removeButton.isEnabled = false
        
        YearsModel.instance.sponsorsRelay.asObservable()
            .subscribe(onNext: { [unowned self] inSponsors in
                self.sponsors = inSponsors
                
            })
            .disposed(by: disposeBag)
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
        
        let data = try? Data.init(contentsOf: URL(fileURLWithPath: path))
        
        let image = NSImage(contentsOfFile: path)
        
        if let image = image, let data = data {
            print("Image exists")
            sheetViewController.image = image
            sheetViewController.imageData = data
            sheetViewController.imageName = name.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
            presentAsSheet(sheetViewController)
        } else {
            print("missing image at: \(path)")
        }
        
    }
    
    @IBAction func remove(_ sender: Any) {
        guard let selected = selectedSponsorIndex else {
            return
        }
        let sponsor = sponsors.remove(at: selected)
        YearsModel.instance.remove(sponsor: sponsor)
        removeButton.isEnabled = false
    }
    
}

extension SponsorsViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
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
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        selectedSponsorIndex = nil
        removeButton.isEnabled = false
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        selectedSponsorIndex = indexPaths.first?.item
        removeButton.isEnabled = true
    }
    
}
