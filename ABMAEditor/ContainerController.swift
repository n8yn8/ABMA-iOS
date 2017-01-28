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
    var years = [String: [String: Event]]()
    var selectedYear: String!
    var eventList = [String: Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for j in 0 ..< 5 {
            let yearName = "201\(j)"
            let theseEvents = [String: Event]()
            years[yearName] = theseEvents
        }
        
        DbManager.sharedInstance.getEvents { (events, error) in
            if let data = events {
                for event in data {
                    self.eventList[event.objectId!] = event
                }
                self.update()
            }
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
    
    func removeSelectedEvent(key: String) {
        eventList.removeValue(forKey: key)
        update()
    }
}

extension ContainerController: EventViewControllerDelegate {
    func updateEvent(event: Event) {
        eventList[event.objectId!] = event
        years[selectedYear] = eventList
        update()
    }
}
