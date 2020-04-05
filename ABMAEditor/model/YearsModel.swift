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
    var years: BehaviorRelay<[BYear]> = BehaviorRelay(value: [])
    var selectedYear: BehaviorRelay<BYear?> = BehaviorRelay(value: nil)
    let sponsors: BehaviorRelay<[BSponsor]> = BehaviorRelay(value: [])
    
    init() {
        DbManager.sharedInstance.getYears { (years, error) in
            if let data = years {
                let sortedYears = data.sorted(by: { (year1, year2) -> Bool in
                    return year1.name > year2.name
                })
                self.years.accept(sortedYears)
            }
        }
    }
}

extension YearsModel {
    func add(year: BYear) {
        DbManager.sharedInstance.update(year: year) { (saved, error) in
            if let savedYear = saved {
                savedYear.doSort()
                let newYears = self.years.value + [savedYear]
                self.years.accept(newYears)
                self.selectedYear.accept(savedYear)
            }
        }
    }
    
    func select(yearName: String) {
        for thisYear in years.value {
            if "\(thisYear.name)" == yearName {
                selectedYear.accept(thisYear)
            }
        }
    }
}

extension YearsModel {
    func add(sponsor: BSponsor) {
        guard let thisYear = selectedYear.value else {
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
        sponsors.accept(thisYear.sponsors!)
    }
    
    func remove(sponsor: BSponsor) {
        DbManager.sharedInstance.delete(sponsor: sponsor)
        
        if let index = selectedYear.value?.sponsors?.firstIndex(of: sponsor) {
            selectedYear.value?.sponsors?.remove(at: index)
        }
        sponsors.accept(selectedYear.value!.sponsors!)
        
    }
}
