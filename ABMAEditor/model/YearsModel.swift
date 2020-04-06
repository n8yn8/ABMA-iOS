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
            
            guard let year = selectedYear else { return }
            if let events = year.events {
                self.events = events
            } else {
                DbManager.sharedInstance.getEvents(parentId: year.objectId!) { (response, error) in
                    let events = response?.sorted(by: { (e1, e2) -> Bool in
                        e1.startDate!.compare(e2.startDate!) == ComparisonResult.orderedAscending
                    })
                    self.selectedYear?.events = events
                    self.events = events ?? []
                }
            }
            if let sponsors = year.sponsors {
                self.sponsors = sponsors
            } else {
                DbManager.sharedInstance.getSponsors(parentId: year.objectId!) { (response, error) in
                    self.selectedYear?.sponsors = response
                    self.sponsors = response ?? []
                }
            }
        }
    }
    let sponsorsRelay: BehaviorRelay<[BSponsor]> = BehaviorRelay(value: [])
    private var sponsors = [BSponsor]() {
        didSet {
            print("didSet sponsors \(sponsors)")
            sponsorsRelay.accept(sponsors)
        }
    }
    
    let eventsRelay: BehaviorRelay<[BEvent]> = BehaviorRelay(value: [])
    private var events = [BEvent]() {
        didSet {
            print("didSet events \(events)")
            eventsRelay.accept(events)
            if let year = selectedYear {
                if year.events != events {
                    print("Events not equal, setting")
                    year.events = events
                } else {
                    print("Events ARE equal, weee")
                }
            }
        }
    }
    
    var selectedEventRelay: BehaviorRelay<BEvent?> = BehaviorRelay(value: nil)
    private var selectedEvent: BEvent? = nil {
        didSet {
            print("didSet selectedEvent \(String(describing: selectedEvent))")
            selectedEventRelay.accept(selectedEvent)
            
            guard let event = selectedEvent else { return }
            if let papers = event.papers {
                self.papers = papers
            } else {
                DbManager.sharedInstance.getPapers(parentId: event.objectId!, callback: { (response, errore) in
                    self.papers = response?.sorted(by: { (paper1, paper2) -> Bool in
                        paper1.order < paper2.order
                    }) ?? []
                })

            }
        }
    }
    
    let papersRelay: BehaviorRelay<[BPaper]> = BehaviorRelay(value: [])
    private var papers = [BPaper]() {
        didSet {
            print("didSet papers \(papers)")
            papersRelay.accept(papers)
            if let event = selectedEvent {
                if event.papers != papers {
                    print("papers not equal, setting")
                    event.papers = papers
                } else {
                    print("papers ARE equal, weee")
                }
            }
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

extension YearsModel {
    
    func update(event: BEvent) {
        guard let yearId = selectedYear?.objectId else {
            return
        }
        event.papersCount = papers.count
        DbManager.sharedInstance.update(event: event, yearParent: yearId) { (saved, error) in
            if let error = error {
                print("udpateEvent error \(error)")
            }
            if let savedEvent = saved {
                if let index = self.events.firstIndex(where: { (eventInArray) -> Bool in
                    savedEvent.objectId == eventInArray.objectId
                }) {
                    self.events[index] = savedEvent
                } else {
                    self.events.append(savedEvent)
                }
            }
        }
    }
    
    func delete(event: BEvent) {
        DbManager.sharedInstance.delete(event: event)
        if let index = self.events.firstIndex(of: event) {
            self.events.remove(at: index)
        }
    }
    
    func select(event: BEvent?) {
        selectedEvent = event
    }
}

extension YearsModel {
    func delete(paper: BPaper) {
        if paper.objectId != nil {
            DbManager.sharedInstance.delete(paper: paper)
        }
    }
    
    func update(paper: BPaper) {
        DbManager.sharedInstance.update(paper: paper, eventParent: selectedEvent!.objectId!) { (saved, error) in
            guard let savedPaper = saved else {
                return
            }
            if let index = self.papers.firstIndex(where: { (arrayPaper) -> Bool in
                savedPaper.objectId! == arrayPaper.objectId
            }) {
                self.papers[index] = savedPaper
            } else {
                self.papers.append(savedPaper)
            }
            if self.papers.count != self.selectedEvent!.papersCount {
                self.update(event: self.selectedEvent!)
            }
        }
    }
}
