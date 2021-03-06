//
//  BYear.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class BYear: NSObject, Codable {
    
    @objc var objectId: String?
    @objc var name = 0
    @objc var events: [BEvent]?
    @objc var welcome: String?
    @objc var info: String?
    @objc var sponsors: [BSponsor]?
    @objc var surveys: String?
    @objc var maps: String?
    @objc var updated: Date?
    @objc var created: Date?
    @objc var publishedAt: Date?
    
    @objc 
    func doSort() {
        guard let theseEvents = events else {
            return
        }
        for event in theseEvents {
            event.doSort()
        }
        let sortedEvents = theseEvents.sorted(by: { (e1, e2) -> Bool in
            e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
        })
        events = sortedEvents
    }
}
