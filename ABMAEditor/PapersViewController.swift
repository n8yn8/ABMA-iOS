//
//  PapersViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/25/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class PapersViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var papersTableView: NSTableView!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var authorTextField: NSTextField!
    @IBOutlet var abstractTextView: NSTextView!
    @IBOutlet weak var saveButton: NSButtonCell!
    @IBOutlet weak var orderStepper: NSStepper!
    @IBOutlet weak var orderTextView: NSTextField!
    
    private var papers = [BPaper]() {
        didSet {
            papersTableView.deselectAll(self)
            papersTableView.reloadData()
            updateSelectedPaper()
        }
    }
    var eventParent: String?
    
    private var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setEnabled(enabled: false)
        
        YearsModel.instance.papersRelay.asObservable()
        .subscribe(onNext: { [unowned self] selectedPapers in
            print("event list observed \(String(describing: selectedPapers))")
            self.papers = selectedPapers
            
        })
        .disposed(by: disposeBag)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return papers.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let paper = papers[row]
        
        let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier.rawValue == "Title" {
            cell.textField?.stringValue = paper.title
        } else if tableColumn!.identifier.rawValue == "Author" {
            cell.textField?.stringValue = paper.author
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateSelectedPaper()
    }
    
    func getSelectedPaper() -> BPaper? {
        let selectedRow = papersTableView.selectedRow
        removeButton.isEnabled = selectedRow >= 0
        if selectedRow >= 0 && papers.count > selectedRow {
            selectedIndex = selectedRow
            return papers[selectedRow]
        }
        selectedIndex = nil
        return nil
    }
    
    func updateSelectedPaper() {
        if let paper = getSelectedPaper() {
            titleTextField.stringValue = paper.title
            authorTextField.stringValue = paper.author
            abstractTextView.string = paper.synopsis
            orderTextView.stringValue = "\(paper.order)"
            orderStepper.integerValue = paper.order
            setEnabled(enabled: true)
        } else {
            titleTextField.stringValue = ""
            authorTextField.stringValue = ""
            abstractTextView.string = ""
            orderTextView.stringValue = "\(0)"
            orderStepper.integerValue = 0
            setEnabled(enabled: false)
        }
    }
    
    func setEnabled(enabled: Bool) {
        titleTextField.isEnabled = enabled
        authorTextField.isEnabled = enabled
        abstractTextView.isSelectable = enabled
        abstractTextView.isEditable = enabled
        saveButton.isEnabled = enabled
        orderStepper.isEnabled = enabled
    }
    
    @IBAction func add(_ sender: Any) {
        papersTableView.deselectAll(self)
        setEnabled(enabled: true)
    }
    
    @IBAction func remove(_ sender: Any) {
        let removedPaper = papers.remove(at: papersTableView.selectedRow)
        YearsModel.instance.delete(paper: removedPaper)
        removeButton.isEnabled = false
    }
    
    @IBAction func save(_ sender: Any) {
        guard eventParent != nil else {
            let alert = NSAlert.init()
            alert.messageText = "Save the event before adding papers."
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }
        
        let title = titleTextField.stringValue
        let author = authorTextField.stringValue
        let abstract = abstractTextView.string
        let order = orderStepper.integerValue
        
        var paper: BPaper
        if let index = selectedIndex {
            paper = papers[index]
        } else {
            paper = BPaper()
        }
        paper.initWith(title: title, author: author, synopsis: abstract, order: order)
        YearsModel.instance.update(paper: paper)
    }
    
    @IBAction func orderChanged(_ sender: NSStepper) {
        orderTextView.stringValue = "\(orderStepper.integerValue)"
    }
}
