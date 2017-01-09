//
//  EventListViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/6/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class EventListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var eventTableView: NSTableView!
    weak var delegate: MasterViewControllerDelegate?
    
    var eventList = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setEventList(list: [Event]) {
        eventList = list
        eventTableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let event = eventList[row]
        
        let cell = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "Time" {
            cell.textField?.stringValue = "time \(row)"
        } else if tableColumn!.identifier == "Title" {
            cell.textField?.stringValue = event.title
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        delegate?.updateSelectedEvent(event: getSelectedEvet())
    }
    
    func getSelectedEvet() -> Event? {
        let selectedRow = eventTableView.selectedRow
        if selectedRow >= 0 && eventList.count > selectedRow {
            return eventList[selectedRow]
        }
        return nil
    }

}

protocol MasterViewControllerDelegate: class {
    func updateSelectedEvent(event: Event?)
}
