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
    var eventList = [BEvent]()
    var selectedEventIndex: Int?
    var yearObjectId: String?
    
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
    
    func updateEventList(events: [BEvent]?, yearObjectId: String?) {
        self.yearObjectId = yearObjectId
        eventList.removeAll()
        if let theseEvents = events {
            eventList.append(contentsOf: theseEvents)
        }
        update()
    }
    
    func update() {
        eventListController.setEventList(list: eventList)
    }
}

extension ContainerController: MasterViewControllerDelegate {
    
    func updateSelectedEvent(event: BEvent?, index: Int?) {
        eventController.representedObject = event
        selectedEventIndex = index
        eventController.setEnabled(enabled: index != nil)
    }
    
    func addNewEvent() {
        eventController.representedObject = nil
        eventController.setEnabled(enabled: true)
    }
    
    func removeSelectedEvent(index: Int) {
        let removedEvent = eventList.remove(at: index)
        DbManager.sharedInstance.deleteEvent(event: removedEvent)
        update()
    }
}

extension ContainerController: EventViewControllerDelegate {
    func updateEvent(event: BEvent) {
        guard let yearId = yearObjectId else {
            return
        }
        DbManager.sharedInstance.update(event: event, yearParent: yearId) { (saved, error) in
            if let index = self.selectedEventIndex, let savedEvent = saved {
                self.eventList[index] = savedEvent
            }
            self.update()
        }
    }
}

protocol ContainerControllerDelegate: class {
    func updateEvents(list: [BEvent])
}
