//
//  ContainerController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/8/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class ContainerController: NSSplitViewController, MasterViewControllerDelegate, EventViewControllerDelegate {
    
    var eventListController: EventListViewController!
    var eventController: EventViewController!
    var eventList = [Date: Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< 5 {
            let event = Event(startDate: Date(), endDate: Date(), title: "title \(i)")
            eventList[event.createdAt] = event
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
        
        eventListController.setEventList(list: eventList)
    }
    
    func update() {
        eventListController.setEventList(list: eventList)
    }
    
    func updateSelectedEvent(event: Event?) {
        eventController.representedObject = event
    }
    
    func removeSelectedEvent(key: Date) {
        eventList.removeValue(forKey: key)
        update()
    }
    
    func updateEvent(event: Event) {
        eventList[event.createdAt] = event
        update()
    }

}
