//
//  YearsModel.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 4/4/20.
//  Copyright © 2020 Nathan Condell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class YearsModel {
    static let instance = YearsModel()
    var yearsRelay: BehaviorRelay<[BYear]> = BehaviorRelay(value: [])
    private var years = [BYear]() {
        didSet {
            yearsRelay.accept(years)
        }
    }
    var selectedYearRelay: BehaviorRelay<BYear?> = BehaviorRelay(value: nil)
    private var selectedYear: BYear? = nil {
        didSet {
            selectedYearRelay.accept(selectedYear)
        }
    }
    let sponsorsRelay: BehaviorRelay<[BSponsor]> = BehaviorRelay(value: [])
    private var sponsors = [BSponsor]() {
        didSet {
            sponsorsRelay.accept(sponsors)
        }
    }
    
    init() {
        DbManager.sharedInstance.getYears { (years, error) in
            if let error = error {
                print("getYears error \(error)")
            }
            if let data = years {
                let sortedYears = data.sorted(by: { (year1, year2) -> Bool in
                    return year1.name > year2.name
                })
                self.years = sortedYears
            }
        }
    }
}

extension YearsModel {
    func add(year: BYear) {
        DbManager.sharedInstance.update(year: year) { (saved, error) in
            if let error = error {
                print("addYear error \(error)")
            }
            if let savedYear = saved {
                savedYear.doSort()
                self.years.append(savedYear)
            }
        }
    }
    
    func select(yearName: String) {
        for thisYear in years {
            if "\(thisYear.name)" == yearName {
                selectedYear = thisYear
            }
        }
    }
}

extension YearsModel {
    private func updateYear() {
        DbManager.sharedInstance.update(year: selectedYear!) { (saved, error) in
            if let error = error {
                print("udpateYear error \(error)")
            }
            saved?.doSort()
            self.selectedYear = saved
        }
    }
    
    func update(surveys: String?) {
        selectedYear?.surveys = surveys
        updateYear()
    }
    
    func update(maps: String?) {
        selectedYear?.maps = maps
        updateYear()
    }
    
    func update(welcome: String, info: String) {
        selectedYear?.welcome = welcome
        selectedYear?.info = info
        updateYear()
    }
}

extension YearsModel {
    func add(sponsor: BSponsor) {
        guard let thisYear = selectedYear else {
            return
        }
        if thisYear.sponsors == nil {
            thisYear.sponsors = [BSponsor]()
        }
        if let id = sponsor.objectId {
            var found = false
            for i in 0 ..< thisYear.sponsors!.count {
                let sponsor = thisYear.sponsors![i]
                if id == sponsor.objectId {
                    found = true
                    thisYear.sponsors![i] = sponsor
                }
            }
            if !found {
                thisYear.sponsors!.append(sponsor)
            }
        } else {
            thisYear.sponsors!.append(sponsor)
        }
        sponsors = thisYear.sponsors!
    }
    
    func remove(sponsor: BSponsor) {
        DbManager.sharedInstance.delete(sponsor: sponsor)
        
        if let index = selectedYear?.sponsors?.firstIndex(of: sponsor) {
            selectedYear?.sponsors?.remove(at: index)
        }
        sponsors = selectedYear!.sponsors!
        
    }
}
