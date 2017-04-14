//
//  YearViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class YearViewController: NSViewController {
    
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    @IBOutlet var welcomeTextView: NSTextView!
    @IBOutlet var infoTextView: NSTextView!
    @IBOutlet weak var surveyLinkTextField: NSTextField!
    @IBOutlet weak var surveyStartDatePicker: NSDatePicker!
    @IBOutlet weak var surveyEndDatePicker: NSDatePicker!
    var containerController: ContainerController?
    var sponsorsViewController: SponsorsViewController?
    
    var years = [BYear]()
    var selectedYear: BYear?
    
    @IBOutlet weak var yearsPopUpButton: NSPopUpButton!
    @IBOutlet weak var publishButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        activityIndicator.startAnimation(self)
        DbManager.sharedInstance.getYears { (years, error) in
            self.activityIndicator.stopAnimation(self)
            if let data = years {
                let sorted = data.sorted(by: { (year1, year2) -> Bool in
                    return year1.name > year2.name
                })
                self.years.removeAll()
                self.years.append(contentsOf: sorted)
                self.updateYearOptions()
            }
        }
    }
    
    func setYears(years: [String]) {
        yearsPopUpButton.addItems(withTitles: years)
        yearSelected(yearsPopUpButton)
    }
    
    @IBAction func yearSelected(_ sender: NSPopUpButton) {
        if !yearsPopUpButton.itemArray.isEmpty {
            let selectedYear = yearsPopUpButton.itemTitle(at: yearsPopUpButton.indexOfSelectedItem)
            updateSeelctedYear(year: selectedYear)
        }
    }
    
    func updateSeelctedYear(year: String) {
        for thisYear in years {
            if "\(thisYear.name)" == year {
                selectedYear = thisYear
                updateUi()
            }
        }
    }
    
    func updateUi() {
        
        
        surveyLinkTextField.stringValue = ""
        surveyStartDatePicker.dateValue = Date()
        surveyEndDatePicker.dateValue = Date()
        
        if let year = selectedYear {
            containerController?.updateEventList(events: year.events)
            if let welcome = year.welcome {
                welcomeTextView.string = welcome
            } else {
                welcomeTextView.string = ""
            }
            if let info = year.info {
                infoTextView.string = info
            } else {
                infoTextView.string = ""
            }
            publishButton.isEnabled = true
            if year.publishedAt == nil{
                publishButton.title = "Publish"
            } else {
                publishButton.title = "Update"
            }
            
            if let surveyLink = year.surveyUrl {
                surveyLinkTextField.stringValue = surveyLink
            }
            
            if let surveyStart = year.surveyStart {
                surveyStartDatePicker.dateValue = surveyStart
            }
            
            if let surveyEnd = year.surveyEnd {
                surveyEndDatePicker.dateValue = surveyEnd
            }
            
            sponsorsViewController?.updateSponsors(sponsorList: year.sponsors)
        } else {
            containerController?.updateEventList(events: [BEvent]())
            welcomeTextView.string = ""
            infoTextView.string = ""
            sponsorsViewController?.updateSponsors(sponsorList: [BSponsor]())
            publishButton.isEnabled = false
            publishButton.title = "Publish"
        }
        
    }
    
    func updateYearOptions() {
        var yearList = [String]()
        for year in years {
            yearList.append("\(year.name)")
        }
        setYears(years: yearList)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let dvc = segue.destinationController as? NewYearsViewController {
            dvc.year = 2017
            dvc.delegate = self
        } else if let dvc = segue.destinationController as? ContainerController {
            containerController = dvc
            containerController?.delegate = self
        } else if let dvc = segue.destinationController as? SponsorsViewController {
            sponsorsViewController = dvc
            sponsorsViewController?.delegate = self
        } else if let dvc = segue.destinationController as? PushViewController {
            dvc.delegate = self
        }
    }
    
    @IBAction func saveWelcome(_ sender: Any) {
        selectedYear?.welcome = welcomeTextView.string
        selectedYear?.info = infoTextView.string
        let surveyLink = surveyLinkTextField.stringValue
        if !surveyLink.isEmpty {
            selectedYear?.surveyUrl = surveyLink
            selectedYear?.surveyStart = surveyStartDatePicker.dateValue
            selectedYear?.surveyEnd = surveyEndDatePicker.dateValue
        }
        updateYear(callback: nil)
    }
    
    func updateYear(callback: (() -> Void)?) {
        activityIndicator.startAnimation(self)
        DbManager.sharedInstance.update(year: selectedYear!) { (saved, error) in
            self.activityIndicator.stopAnimation(self)
            self.selectedYear = saved
            self.updateUi()
        }
    }
    
    @IBAction func publish(_ sender: Any) {
        updateYear(callback: nil)
    }
}

extension YearViewController: NewYearsViewControllerDelegate {
    func yearCreated(year: Int) {
        for checkYear in years {
            if checkYear.name == year {
                selectedYear = checkYear
                updateYearOptions()
                yearsPopUpButton.selectItem(withTitle: "\(year)")
                yearSelected(yearsPopUpButton)
                return
            }
        }
        let thisYear = BYear()
        thisYear.name = year
        DbManager.sharedInstance.update(year: thisYear) { (saved, error) in
            if let savedYear = saved {
                self.years.append(savedYear)
                self.updateYearOptions()
            }
        }
    }
}

extension YearViewController: SponsorsViewControllerDelegate {
    func saveSponsor(savedSponsor: BSponsor) {
        if let thisYear = selectedYear {
            if let id = savedSponsor.objectId {
                for i in 0 ..< thisYear.sponsors.count {
                    let sponsor = selectedYear?.sponsors[i]
                    if id == sponsor?.objectId {
                        selectedYear?.sponsors[i] = savedSponsor
                    }
                }
            } else {
                selectedYear?.sponsors.append(savedSponsor)
            }
            updateYear(callback: nil)
        }
        
    }
}

extension YearViewController: ContainerControllerDelegate {
    func updateEvents(list: [BEvent]) {
        selectedYear?.events = list
        updateYear(callback: nil)
    }
}

extension YearViewController: PushViewControllerDelegate {
    func sendUpdate(message: String) {
        if selectedYear?.publishedAt == nil {
            selectedYear?.publishedAt = Date()
            updateYear(callback: { 
                DbManager.sharedInstance.pushUpdate(message: message)
            })
        } else {
            DbManager.sharedInstance.pushUpdate(message: message)
        }
    }
}
