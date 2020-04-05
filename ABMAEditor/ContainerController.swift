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
    var yearObjectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for splitItem in splitViewItems {
            if splitItem.viewController is EventListViewController {
                eventListController = (splitItem.viewController as! EventListViewController)
            } else if splitItem.viewController is EventViewController {
                eventController = (splitItem.viewController as! EventViewController)
            }
        }
        eventController.delegate = self

    }
}

extension ContainerController: EventViewControllerDelegate {
    func updateEvent(event: BEvent) {
        
    }
}

protocol ContainerControllerDelegate: class {
    func updateEvents(list: [BEvent])
}
