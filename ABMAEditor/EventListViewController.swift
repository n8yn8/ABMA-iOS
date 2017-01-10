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
    @IBOutlet weak var yearsPopUpButton: NSPopUpButton!
    weak var delegate: MasterViewControllerDelegate?
    
    private let formatter = DateFormatter()
    
    private var eventList = [Date: Event]()
    private var eventListKeys = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }
    
    func setYears(years: [String]) {
        yearsPopUpButton.addItems(withTitles: years)
        yearSelected(self)
    }
    
    func setEventList(list: [Date: Event]) {
        eventList = list
        eventListKeys = Array(list.keys).sorted(by: { (first, second) -> Bool in
            first.compare(second) == .orderedAscending
        })
        eventTableView.reloadData()
    }
    
    @IBAction func yearSelected(_ sender: Any) {
        let selectedYear = yearsPopUpButton.itemTitle(at: yearsPopUpButton.indexOfSelectedItem)
        delegate?.updateSeelctedYear(year: selectedYear)
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
        removeButton.isEnabled = selectedRow >= 0
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
        removeButton.isEnabled = false
    }
}

protocol MasterViewControllerDelegate: class {
    func updateSeelctedYear(year: String)
    func updateSelectedEvent(event: Event?)
    func removeSelectedEvent(key: Date)
}
