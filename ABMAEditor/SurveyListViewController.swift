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
    @IBOutlet weak var removeButton: NSButton!
    
    weak var delegate: SurveyListViewControllerDelegate?
    var surveysString: String? {
        didSet {
            if let string = surveysString {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    surveys = try decoder.decode([BSurvey].self, from: string.data(using: .utf8)!)
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    surveys = [BSurvey]()
                }
            } else {
                surveys = [BSurvey]()
            }
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
        } else if tableColumn!.identifier.rawValue == "Details" {
            cell.textField?.stringValue = survey.details
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateSelectedSurvey()
    }
    
    func updateSelectedSurvey() {
        surveyViewController?.survey = getSelectedSurvey()
    }
    
    func getSelectedSurvey() -> BSurvey? {
        let selectedRow = surveysTableView.selectedRow
        removeButton.isEnabled = selectedRow >= 0
        if selectedRow >= 0 && surveys.count > selectedRow {
            selectedIndex = selectedRow
            return surveys[selectedRow]
        }
        selectedIndex = nil
        return nil
    }
    
    @IBAction func add(_ sender: Any) {
        surveysTableView.deselectAll(self)
        surveyViewController?.setEnabled(isEnabled: true)
    }
    
    @IBAction func remove(_ sender: Any) {
        surveys.remove(at: surveysTableView.selectedRow)
        save()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? SurveyViewController {
            surveyViewController = controller
            surveyViewController?.delegate = self
        }
    }
    
    private func save() {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .custom({ (date, encoder) in
                let number = Int(date.timeIntervalSince1970 * 1000)
                var container = encoder.singleValueContainer()
                try container.encode(number)
            })
            let jsonData = try jsonEncoder.encode(surveys)
            let string = String(data: jsonData, encoding: String.Encoding.utf8)
            delegate?.saveSurveys(surveys: string!)
        } catch {
            print("error trying to convert object to data")
            print(error)
        }
    }
    
}

extension SurveyListViewController: SurveyViewControllerDelegate {
    
    func saveSurvey(survey: BSurvey) {
        surveys.append(survey)
        save()
    }
    
}

protocol SurveyListViewControllerDelegate: class {
    func saveSurveys(surveys: String)
}
