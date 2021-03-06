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
    
    private let formatter = DateFormatter()
    
    private var eventList = [BEvent]()
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }
    
    func setEventList(list: [BEvent]) {
        eventList = list
        eventTableView.deselectAll(self)
        eventTableView.reloadData()
        updateSelectedEvent()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let event = eventList[row]
        
        let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier.rawValue == "Time" {
            let dateUTC = event.startDate.addingTimeInterval(TimeInterval(-TimeZone.current.secondsFromGMT()))
            cell.textField?.stringValue = formatter.string(from: dateUTC)
        } else if tableColumn!.identifier.rawValue == "Title" {
            if let title = event.title {
                cell.textField?.stringValue = title
            } else {
                cell.textField?.stringValue = ""
            }
            
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateSelectedEvent()
    }
    
    private func updateSelectedEvent() {
        delegate?.updateSelectedEvent(event: getSelectedEvent(), index: selectedIndex)
    }
    
    func getSelectedEvent() -> BEvent? {
        let selectedRow = eventTableView.selectedRow
        removeButton.isEnabled = selectedRow >= 0
        if selectedRow >= 0 && eventList.count > selectedRow {
            selectedIndex = selectedRow
            return eventList[selectedRow]
        }
        selectedIndex = nil
        return nil
    }
    
    @IBAction func add(_ sender: Any) {
        delegate?.addNewEvent()
    }

    @IBAction func remove(_ sender: Any) {
        delegate?.removeSelectedEvent(index: eventTableView.selectedRow)
        removeButton.isEnabled = false
    }
    
}

protocol MasterViewControllerDelegate: class {
    func updateSelectedEvent(event: BEvent?, index: Int?)
    func addNewEvent()
    func removeSelectedEvent(index: Int)
}
