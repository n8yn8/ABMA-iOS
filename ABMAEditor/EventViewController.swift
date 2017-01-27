//
//  ViewController.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 1/2/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class EventViewController: NSViewController, PapersViewControllerDelegate {

    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var startTimePicker: NSDatePicker!
    @IBOutlet weak var endTimePicker: NSDatePicker!
    @IBOutlet weak var locationTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var subtitleTextField: NSTextField!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var tabView: NSTabView!
    
    weak var delegate: EventViewControllerDelegate?
    
    private let calendar = Calendar.current
    fileprivate var event: Event?
    fileprivate var papersViewController: PapersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.calendar = self.calendar
        datePicker.dateValue = Date()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            datePicker.dateValue = Date()
            startTimePicker.dateValue = Date()
            endTimePicker.dateValue = Date()
            locationTextField.stringValue = ""
            titleTextField.stringValue = ""
            subtitleTextField.stringValue = ""
            descriptionTextView.string = ""
            
            if let event = representedObject as? Event {
                self.event = event
                
                datePicker.dateValue = event.startDate
                startTimePicker.dateValue = event.startDate
                endTimePicker.dateValue = event.endDate
                if let location = event.location {
                    locationTextField.stringValue = location
                }
                titleTextField.stringValue = event.title
                if let subtitle = event.subtitle {
                    subtitleTextField.stringValue = subtitle
                }
                if let details = event.details {
                    descriptionTextView.string = details
                    tabView.selectFirstTabViewItem(self)
                } else  if !event.papers.isEmpty {
                    tabView.selectLastTabViewItem(self)
                }
                if let controller = papersViewController {
                    controller.papers = event.papers
                }
                
            } else{
                self.event = nil
            }
        }
    }

    @IBAction func save(_ sender: NSButton) {
        
        let startDate = buildDate(timePart: startTimePicker.dateValue)
        let endDate = buildDate(timePart: endTimePicker.dateValue)
        
        if event == nil {
            event = Event(startDate: startDate, endDate: endDate, title: titleTextField.stringValue)
        } else {
            event?.startDate = startDate
            event?.endDate = endDate
            event?.title = titleTextField.stringValue
        }
        
        event!.location = locationTextField.stringValue
        event!.subtitle = subtitleTextField.stringValue
        event!.details = descriptionTextView.string
        event!.updatedAt = Date()
        
        delegate?.updateEvent(event: event!)
    }
    
    func buildDate(timePart: Date) -> Date {
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timePart)
        let date = calendar.startOfDay(for: datePicker.dateValue)
        let finalDate = calendar.date(byAdding: timeComponents, to: date)!
        return finalDate
    }
    
    func updatePapers(papers: [Paper]) {
        event?.papers = papers
        delegate?.updateEvent(event: event!)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? PapersViewController {
            papersViewController = controller
            papersViewController?.delegate = self
        }
    }

}

protocol EventViewControllerDelegate: class {
    func updateEvent(event: Event)
}
