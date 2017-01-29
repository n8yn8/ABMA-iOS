//
//  YearViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class YearViewController: NSViewController {
    
    @IBOutlet var welcomeTextView: NSTextView!
    @IBOutlet var infoTextView: NSTextView!
    var containerController: ContainerController?
    var sponsorsViewController: SponsorsViewController?
    
    var years = [String: Year]()
    var selectedYear: Year?
    
    @IBOutlet weak var yearsPopUpButton: NSPopUpButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        DbManager.sharedInstance.getYears { (years, error) in
            if let data = years {
                self.years.removeAll()
                for year in data {
                    self.years[year.objectId!] = year
                }
                self.updateYearOptions()
            }
        }
    }
    
    func setYears(years: [String]) {
        yearsPopUpButton.addItems(withTitles: years)
        yearsPopUpButton.selectItem(at: 0)
    }
    
    @IBAction func yearSelected(_ sender: NSPopUpButton) {
        if !yearsPopUpButton.itemArray.isEmpty {
            let selectedYear = yearsPopUpButton.itemTitle(at: yearsPopUpButton.indexOfSelectedItem)
            updateSeelctedYear(year: selectedYear)
        }
    }
    
    func updateSeelctedYear(year: String) {
        for thisYear in Array(years.values) {
            if "\(thisYear.name)" == year {
                selectedYear = thisYear
                updateUi()
            }
        }
    }
    
    func updateUi() {
        if let year = selectedYear {
            containerController?.updateEventList(events: year.events)
            welcomeTextView.string = year.welcome
            infoTextView.string = year.info
            sponsorsViewController?.updateSponsors(sponsorList: year.sponsors)
        } else {
            containerController?.updateEventList(events: [Event]())
            welcomeTextView.string = ""
            infoTextView.string = ""
            sponsorsViewController?.updateSponsors(sponsorList: [Sponsor]())
        }
        
    }
    
    func updateYearOptions() {
        var yearList = [String]()
        for year in Array(years.values) {
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
        } else if let dvc = segue.destinationController as? SponsorsViewController {
            sponsorsViewController = dvc
            sponsorsViewController?.delegate = self
        }
    }
    
    @IBAction func saveWelcome(_ sender: Any) {
        selectedYear?.welcome = welcomeTextView.string
        updateYear()
    }
    
    @IBAction func saveInfo(_ sender: Any) {
        selectedYear?.info = infoTextView.string
        updateYear()
    }
    
    func updateYear() {
        DbManager.sharedInstance.update(year: selectedYear!) { (saved, error) in
            self.selectedYear = saved
            self.updateUi()
        }
    }
}

extension YearViewController: NewYearsViewControllerDelegate {
    func yearCreated(year: Int) {
        let thisYear = Year()
        thisYear.name = year
        DbManager.sharedInstance.update(year: thisYear) { (saved, error) in
            if let savedYear = saved {
                self.years[savedYear.objectId!] = savedYear
                self.updateYearOptions()
            }
        }
    }
}

extension YearViewController: SponsorsViewControllerDelegate {
    func saveSponsor(savedSponsor: Sponsor) {
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
            updateYear()
        }
        
    }
}
