//
//  SurveyListViewController.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 3/7/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

import Cocoa

class SurveyListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var surveysTableView: NSTableView!
    var surveysString = "" {
        didSet {
        }
    }
    private var surveys = [BSurvey](){
        didSet {
            surveysTableView.deselectAll(self)
            surveysTableView.reloadData()
        }
    }
    private var selectedIndex: Int?
    private var surveyViewController: SurveyViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return surveys.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let survey = surveys[row]
        
        let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier.rawValue == "Title" {
            cell.textField?.stringValue = survey.title
        } else if tableColumn!.identifier.rawValue == "Author" {
            
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateSelectedPaper()
    }
    
    func updateSelectedPaper() {
        surveyViewController?.survey = getSelectedSurvey()
    }
    
    func getSelectedSurvey() -> BSurvey? {
        let selectedRow = surveysTableView.selectedRow
//        removeButton.isEnabled = selectedRow >= 0
        if selectedRow >= 0 && surveys.count > selectedRow {
            selectedIndex = selectedRow
            return surveys[selectedRow]
        }
        selectedIndex = nil
        return nil
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? SurveyViewController {
            surveyViewController = controller
        }
    }
    
}
