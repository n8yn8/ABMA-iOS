//
//  ContainerController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/8/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class ContainerController: NSSplitViewController {
    
    var eventListController: EventListViewController!
    var eventController: EventViewController!
    var years = [String: [Date: Event]]()
    var selectedYear: String!
    var eventList = [Date: Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for j in 0 ..< 5 {
            let yearName = "201\(j)"
            var theseEvents = [Date: Event]()
            for i in 0 ..< 5 {
                let event = Event(startDate: Date(), endDate: Date(), title: "title \(i) \(j)")
                theseEvents[event.createdAt] = event
            }
            years[yearName] = theseEvents
        }
        
        
        for splitItem in splitViewItems {
            if splitItem.viewController is EventListViewController {
                eventListController = splitItem.viewController as! EventListViewController
            } else if splitItem.viewController is EventViewController {
                eventController = splitItem.viewController as! EventViewController
            }
        }
        eventListController.delegate = self
        eventController.delegate = self
        
        eventListController.setYears(years: Array(years.keys))
    }
    
    func update() {
        eventListController.setEventList(list: eventList)
    }
}

extension ContainerController: MasterViewControllerDelegate {
    func updateSeelctedYear(year: String) {
        selectedYear = year
        eventList = years[year]!
        update()
    }
    
    func updateSelectedEvent(event: Event?) {
        eventController.representedObject = event
    }
    
    func removeSelectedEvent(key: Date) {
        eventList.removeValue(forKey: key)
        update()
    }
}

extension ContainerController: EventViewControllerDelegate {
    func updateEvent(event: Event) {
        eventList[event.createdAt] = event
        years[selectedYear] = eventList
        update()
    }
}
