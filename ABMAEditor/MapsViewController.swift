//
//  MapsViewController.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 3/31/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

import Cocoa

class MapsViewController: NSViewController {
    
    private var maps = [BMap]() {
        didSet {
            collectionView.deselectAll(self)
            collectionView.reloadData()
        }
    }
    var yearParentId: String!
    private var selectedMapIndex: Int?
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var removeButton: NSButton!
    
    weak var delegate: MapsViewControllerDelegate?
    lazy var sheetViewController: NewMapViewController = {
        let vc = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "NewMapViewController"))
            as! NewMapViewController
        vc.yearParentId = yearParentId
        return vc
    }()
    var mapsString: String? {
        didSet {
            if let string = mapsString {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    maps = try decoder.decode([BMap].self, from: string.data(using: .utf8)!)
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    maps = [BMap]()
                }
            } else {
                maps = [BMap]()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        configureCollectionView()
        removeButton.isEnabled = false
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
        guard let selected = selectedMapIndex else {
            return
        }
        let map = maps.remove(at: selected)
        DbManager.sharedInstance.delete(map: map)
        saveMaps()
        collectionView.reloadData()
        removeButton.isEnabled = false
    }
    
    private func saveMaps() {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .custom({ (date, encoder) in
                let number = Int(date.timeIntervalSince1970 * 1000)
                var container = encoder.singleValueContainer()
                try container.encode(number)
            })
            let jsonData = try jsonEncoder.encode(maps)
            let string = String(data: jsonData, encoding: String.Encoding.utf8)
            delegate?.saveMaps(mapsString: string!)
        } catch {
            print("error trying to convert object to data")
            print(error)
        }
    }
    
}

extension MapsViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return maps.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MapViewItem"), for: indexPath)
        guard let mapItem = item as? MapViewItem else {return item}
        
        mapItem.map = maps[indexPath.item]
        
        return mapItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        selectedMapIndex = nil
        removeButton.isEnabled = false
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        selectedMapIndex = indexPaths.first?.item
        removeButton.isEnabled = true
    }
    
}

extension MapsViewController: NewMapViewControllerDelegate {
    func saveMap(map: BMap) {
        maps.append(map)
        collectionView.reloadData()
        saveMaps()
    }
}

protocol MapsViewControllerDelegate: class {
    func saveMaps(mapsString: String)
}
