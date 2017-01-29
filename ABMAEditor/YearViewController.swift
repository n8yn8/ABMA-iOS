//
//  YearViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class YearViewController: NSViewController {
    
    var containerController: ContainerController?
    
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
                containerController?.updateEventList(events: thisYear.events)
            }
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
