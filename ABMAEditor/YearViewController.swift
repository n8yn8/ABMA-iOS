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
    var containerController: ContainerController?
    var sponsorsViewController: SponsorsViewController?
    var surveyListViewController: SurveyListViewController?
    var mapsViewController: MapsViewController?
    
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
                let sortedYears = data.sorted(by: { (year1, year2) -> Bool in
                    return year1.name > year2.name
                })
                self.years.removeAll()
                self.years.append(contentsOf: sortedYears)
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
        
        if let year = selectedYear {
            if var events = year.events {
                events = events.sorted(by: { (e1, e2) -> Bool in
                    e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
                })
                containerController?.updateEventList(events: events, yearObjectId: year.objectId)
            } else {
                DbManager.sharedInstance.getEvents(parentId: year.objectId!) { (response, error) in
                    year.events = response?.sorted(by: { (e1, e2) -> Bool in
                        e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
                    })
                    self.containerController?.updateEventList(events: year.events, yearObjectId: year.objectId)
                }
            }
            
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
            if let sponsors = year.sponsors {
                sponsorsViewController?.updateSponsors(sponsorList: sponsors)
            } else {
                DbManager.sharedInstance.getSponsors(parentId: year.objectId!) { (response, error) in
                    year.sponsors = response
                    self.sponsorsViewController?.updateSponsors(sponsorList: response)
                }
            }
            
            sponsorsViewController?.yearParentId = year.objectId
            surveyListViewController?.surveysString = year.surveys
            mapsViewController?.mapsString = year.maps
        } else {
            containerController?.updateEventList(events: nil, yearObjectId: nil)
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
        } else if let dvc = segue.destinationController as? SurveyListViewController {
            surveyListViewController = dvc
            surveyListViewController?.delegate = self
        } else if let dvc = segue.destinationController as? MapsViewController {
            mapsViewController = dvc
            mapsViewController?.delegate = self
        }
    }
    
    @IBAction func saveWelcome(_ sender: Any) {
        selectedYear?.welcome = welcomeTextView.string
        selectedYear?.info = infoTextView.string
        updateYear(callback: nil)
    }
    
    func updateYear(callback: (() -> Void)?) {
        activityIndicator.startAnimation(self)
        DbManager.sharedInstance.update(year: selectedYear!) { (saved, error) in
            self.activityIndicator.stopAnimation(self)
            saved?.doSort()
            self.selectedYear = saved
            self.updateUi()
            if let call = callback {
                call()
            }
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
                savedYear.doSort()
                self.years.append(savedYear)
                self.updateYearOptions()
            }
        }
    }
}

extension YearViewController: SponsorsViewControllerDelegate {
    func saveSponsor(savedSponsor: BSponsor) {
        if let thisYear = selectedYear {
            if thisYear.sponsors == nil {
                thisYear.sponsors = [BSponsor]()
            }
            if let id = savedSponsor.objectId {
                var found = false
                for i in 0 ..< thisYear.sponsors!.count {
                    let sponsor = thisYear.sponsors![i]
                    if id == sponsor.objectId {
                        found = true
                        thisYear.sponsors![i] = savedSponsor
                    }
                }
                if !found {
                    thisYear.sponsors!.append(savedSponsor)
                }
            } else {
                thisYear.sponsors!.append(savedSponsor)
            }
            thisYear.doSort()
            self.updateUi()
        }
        
    }
}

extension YearViewController: ContainerControllerDelegate {
    func updateEvents(list: [BEvent]) {
        selectedYear?.events = list
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
            updateYear(callback: {
                DbManager.sharedInstance.pushUpdate(message: message)
            })
        }
    }
}

extension YearViewController: SurveyListViewControllerDelegate {
    func saveSurveys(surveys: String) {
        selectedYear?.surveys = surveys
        updateYear(callback: nil)
    }
}

extension YearViewController: MapsViewControllerDelegate {
    func saveMaps(mapsString: String) {
        selectedYear?.maps = mapsString
        updateYear(callback: nil)
    }
}
