//
//  ContainerController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/8/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class ContainerController: NSSplitViewController, MasterViewControllerDelegate {
    
    var eventListController: EventListViewController!
    var eventController: EventViewController!
    var eventList = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< 5 {
            let event = Event(startDate: Date(), endDate: Date(), title: "title \(i)")
            eventList.append(event)
        }
        
        for splitItem in splitViewItems {
            if splitItem.viewController is EventListViewController {
                eventListController = splitItem.viewController as! EventListViewController
            } else if splitItem.viewController is EventViewController {
                eventController = splitItem.viewController as! EventViewController
            }
        }
        eventListController.delegate = self
        
        eventListController.setEventList(list: eventList)
    }
    
    func updateSelectedEvent(event: Event?) {
        eventController.representedObject = event
    }

}
