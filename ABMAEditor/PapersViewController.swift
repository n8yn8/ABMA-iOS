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
    
    var papers = [Paper]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        for j in 0 ..< 5 {
            let paper = Paper(title: "title \(j)", author: "author \(j)", abstract: "Some abstract \(j)")
            papers.append(paper)
        }
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
    
    func getSelectedPaper() -> Paper? {
        let selectedRow = papersTableView.selectedRow
        removeButton.isEnabled = selectedRow >= 0
        if selectedRow >= 0 && papers.count > selectedRow {
            return papers[selectedRow]
        }
        return nil
    }
    
    func updateSelectedPaper() {
        if let paper = getSelectedPaper() {
            titleTextField.stringValue = paper.title
            authorTextField.stringValue = paper.author
            abstractTextView.string = paper.abstract
            saveButton.isEnabled = true
        } else {
            titleTextField.stringValue = ""
            authorTextField.stringValue = ""
            abstractTextView.string = ""
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func add(_ sender: Any) {
        papersTableView.deselectAll(self)
    }
    
    @IBAction func remove(_ sender: Any) {
        papers.remove(at: papersTableView.selectedRow)
        papersTableView.reloadData()
        removeButton.isEnabled = false
        updateSelectedPaper()
    }
    
    @IBAction func save(_ sender: Any) {
    }
}
