//
//  Event.swift
//  ABMA
//
//  Created by Nathan Condell on 1/3/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class Event: NSObject {
    
    var objectId: String?
    var details: String?
    var endDate: Date!
    var location: String?
    var startDate: Date!
    var subtitle: String?
//    var time: String?
    var title: String!
    var created: Date!
    var updated: Date?
//    var day: Day
//    var note: Note
    var papers = [Paper]()
    
    func initWith(startDate: Date, endDate: Date, title: String) {
        
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
    }
}
