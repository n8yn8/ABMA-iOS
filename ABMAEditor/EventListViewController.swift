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
    @IBOutlet weak var removeButton: NSButton!
    weak var delegate: MasterViewControllerDelegate?
    
    let formatter = DateFormatter()
    
    var eventList = [Date: Event]()
    var eventListKeys = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }
    
    func setEventList(list: [Date: Event]) {
        eventList = list
        eventListKeys = Array(list.keys).sorted(by: { (first, second) -> Bool in
            first.compare(second) == .orderedAscending
        })
        eventTableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let event = eventList[eventListKeys[row]]!
        
        let cell = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "Time" {
            cell.textField?.stringValue = formatter.string(from: event.startDate)
        } else if tableColumn!.identifier == "Title" {
            cell.textField?.stringValue = event.title
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        delegate?.updateSelectedEvent(event: getSelectedEvent())
    }
    
    func getSelectedEvent() -> Event? {
        let selectedRow = eventTableView.selectedRow
        if selectedRow >= 0 && eventList.count > selectedRow {
            return eventList[eventListKeys[selectedRow]]
        }
        return nil
    }
    
    @IBAction func add(_ sender: Any) {
        delegate?.updateSelectedEvent(event: nil)
    }

    @IBAction func remove(_ sender: Any) {
        delegate?.removeSelectedEvent(key: eventListKeys[eventTableView.selectedRow])
    }
}

protocol MasterViewControllerDelegate: class {
    func updateSelectedEvent(event: Event?)
    func removeSelectedEvent(key: Date)
}
