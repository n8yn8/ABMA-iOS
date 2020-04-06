//
//  ViewController.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 1/2/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class EventViewController: NSViewController {
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var startTimePicker: NSDatePicker!
    @IBOutlet weak var endTimePicker: NSDatePicker!
    @IBOutlet weak var includeEndTimeButton: NSButton!
    @IBOutlet weak var locationTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var subtitleTextField: NSTextField!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var saveButton: NSButton!
    
    
    private let calendar = Calendar.current
    private var event: BEvent?
    fileprivate var papersViewController: PapersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEnabled(enabled: false)
        
        datePicker.calendar = self.calendar
        datePicker.dateValue = Date()

        YearsModel.instance.selectedEventRelay.asObservable()
        .subscribe(onNext: { [unowned self] selectedEvent in
            print("event observed \(String(describing: selectedEvent))")
            self.representedObject = selectedEvent
            
        })
        .disposed(by: disposeBag)
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
            
            if let event = representedObject as? BEvent {
                setEnabled(enabled: true)
                self.event = event
                
                let utcOffset = TimeInterval(-TimeZone.current.secondsFromGMT())
                if let startDate = event.startDate {
                    datePicker.dateValue = startDate.addingTimeInterval(utcOffset)
                    startTimePicker.dateValue = startDate.addingTimeInterval(utcOffset)
                }
                if let endDate = event.endDate {
                    endTimePicker.dateValue = endDate.addingTimeInterval(utcOffset)
                    endTimePicker.isHidden = false
                    includeEndTimeButton.state = NSControl.StateValue(rawValue: 1)
                } else {
                    endTimePicker.isHidden = true
                    includeEndTimeButton.state = NSControl.StateValue(rawValue: 0)
                }
                if let location = event.location {
                    locationTextField.stringValue = location
                }
                if let title = event.title {
                    titleTextField.stringValue = title
                }
                
                if let subtitle = event.subtitle {
                    subtitleTextField.stringValue = subtitle
                }
                if let details = event.details {
                    descriptionTextView.string = details
                    tabView.selectFirstTabViewItem(self)
                }
                if event.papersCount > 0 {
                    tabView.selectLastTabViewItem(self)
                }
                
                setEnabled(enabled: true)
                
                if let controller = papersViewController {
                    controller.eventParent = event.objectId
                }
                
            } else{
                self.event = nil
                tabView.selectFirstTabViewItem(self)
                setEnabled(enabled: false)
            }
        }
    }
    
    private func setEnabled(enabled: Bool) {
        datePicker.isEnabled = enabled
        startTimePicker.isEnabled = enabled
        endTimePicker.isEnabled = enabled
        includeEndTimeButton.isEnabled = enabled
        locationTextField.isEnabled = enabled
        titleTextField.isEnabled = enabled
        subtitleTextField.isEnabled = enabled
        descriptionTextView.isEditable = enabled
        descriptionTextView.isSelectable = enabled
        saveButton.isEnabled = enabled
    }

    @IBAction func save(_ sender: NSButton) {
        saveEvent()
    }
    
    @IBAction func toggleIncludeEnd(_ sender: Any) {
        endTimePicker.isHidden = includeEndTimeButton.state.rawValue == 0
        endTimePicker.isEnabled = includeEndTimeButton.state.rawValue == 1
    }
    
    func saveEvent() {
        let startDate = buildDate(timePartInCurTZ: startTimePicker.dateValue)
        let endDate = includeEndTimeButton.state.rawValue == 1 ? buildDate(timePartInCurTZ: endTimePicker.dateValue) : nil
        
        let thisEvent = event ?? BEvent()
        thisEvent.startDate = startDate
        thisEvent.endDate = endDate
        thisEvent.title = titleTextField.stringValue
        thisEvent.location = locationTextField.stringValue
        thisEvent.subtitle = subtitleTextField.stringValue
        thisEvent.details = descriptionTextView.string
        
        YearsModel.instance.update(event: thisEvent)
    }
    
    func buildDate(timePartInCurTZ: Date) -> Date {
        let timePart = timePartInCurTZ.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timePart)
        let datePart = datePicker.dateValue.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        let date = calendar.startOfDay(for: datePart)
        let finalDate = calendar.date(byAdding: timeComponents, to: date)!
        return finalDate
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? PapersViewController {
            papersViewController = controller
        }
    }

}
