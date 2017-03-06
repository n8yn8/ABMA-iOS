//
//  PapersViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/25/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class PapersViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var papersTableView: NSTableView!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var authorTextField: NSTextField!
    @IBOutlet var abstractTextView: NSTextView!
    @IBOutlet weak var saveButton: NSButtonCell!
    
    var papers = [BPaper]() {
        didSet {
            papersTableView.deselectAll(self)
            papersTableView.reloadData()
        }
    }
    
    private var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setEnabled(enabled: false)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return papers.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let paper = papers[row]
        
        let cell = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "Title" {
            cell.textField?.stringValue = paper.title
        } else if tableColumn!.identifier == "Author" {
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
            setEnabled(enabled: true)
        } else {
            titleTextField.stringValue = ""
            authorTextField.stringValue = ""
            abstractTextView.string = ""
            setEnabled(enabled: false)
        }
    }
    
    func setEnabled(enabled: Bool) {
        titleTextField.isEnabled = enabled
        authorTextField.isEnabled = enabled
        abstractTextView.isSelectable = enabled
        abstractTextView.isEditable = enabled
        saveButton.isEnabled = enabled
    }
    
    @IBAction func add(_ sender: Any) {
        papersTableView.deselectAll(self)
        setEnabled(enabled: true)
    }
    
    @IBAction func remove(_ sender: Any) {
        let removedPaper = papers.remove(at: papersTableView.selectedRow)
        if removedPaper.objectId != nil {
            DbManager.sharedInstance.deletePaper(paper: removedPaper)
        }
        papersTableView.reloadData()
        removeButton.isEnabled = false
        updateSelectedPaper()
    }
    
    @IBAction func save(_ sender: Any) {
        let title = titleTextField.stringValue
        let author = authorTextField.stringValue
        let abstract = abstractTextView.string
        
        var paper: BPaper
        if let index = selectedIndex {
            paper = papers[index]
        } else {
            paper = BPaper()
        }
        paper.initWith(title: title, author: author, synopsis: abstract!)
        
        if let index = selectedIndex {
            self.papers[index] = paper
        } else {
            self.papers.append(paper)
        }
        
        self.papersTableView.reloadData()
        self.papersTableView.selectRowIndexes(NSIndexSet(index: papers.count - 1) as IndexSet, byExtendingSelection: false)
    }
}
