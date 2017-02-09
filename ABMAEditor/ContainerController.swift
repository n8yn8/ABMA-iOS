//
//  ContainerController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/8/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class ContainerController: NSSplitViewController {
    
    weak var delegate: ContainerControllerDelegate?
    
    var eventListController: EventListViewController!
    var eventController: EventViewController!
    var eventList = [String: Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for splitItem in splitViewItems {
            if splitItem.viewController is EventListViewController {
                eventListController = splitItem.viewController as! EventListViewController
            } else if splitItem.viewController is EventViewController {
                eventController = splitItem.viewController as! EventViewController
            }
        }
        eventListController.delegate = self
        eventController.delegate = self

    }
    
    func updateEventList(events: [Event]) {
        eventList.removeAll()
        for event in events {
            eventList[event.objectId!] = event
        }
        update()
    }
    
    func update() {
        eventListController.setEventList(list: eventList)
    }
}

extension ContainerController: MasterViewControllerDelegate {
    
    func updateSelectedEvent(event: Event?) {
        eventController.representedObject = event
    }
    
    func removeSelectedEvent(key: String) {
        let removedEvent = eventList.removeValue(forKey: key)
        DbManager.sharedInstance.deleteEvent(event: removedEvent!)
        update()
    }
}

extension ContainerController: EventViewControllerDelegate {
    func updateEvent(event: Event) {
        DbManager.sharedInstance.updateEvent(event: event) { (saved, error) in
            
        }
        eventList[event.objectId!] = event
        update()
    }
    
    func createEvent(event: Event) {
        var list = Array(eventList.values)
        list.append(event)
        delegate?.updateEvents(list: list)
    }
}

protocol ContainerControllerDelegate: class {
    func updateEvents(list: [Event])
}
