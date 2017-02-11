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
    var eventList = [Event]()
    var selectedEventIndex: Int?
    
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
        eventList.append(contentsOf: events)
        update()
    }
    
    func update() {
        eventListController.setEventList(list: eventList)
    }
}

extension ContainerController: MasterViewControllerDelegate {
    
    func updateSelectedEvent(event: Event?, index: Int?) {
        eventController.representedObject = event
        selectedEventIndex = index
    }
    
    func removeSelectedEvent(index: Int) {
        let removedEvent = eventList.remove(at: index)
        DbManager.sharedInstance.deleteEvent(event: removedEvent)
        update()
    }
}

extension ContainerController: EventViewControllerDelegate {
    func updateEvent(event: Event) {
        DbManager.sharedInstance.updateEvent(event: event) { (saved, error) in
            
        }
        if let index = selectedEventIndex {
            eventList[index] = event
        }
        update()
    }
    
    func createEvent(event: Event) {
        eventList.append(event)
        delegate?.updateEvents(list: eventList)
    }
}

protocol ContainerControllerDelegate: class {
    func updateEvents(list: [Event])
}
