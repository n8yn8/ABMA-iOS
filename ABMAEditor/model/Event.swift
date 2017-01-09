//
//  Event.swift
//  ABMA
//
//  Created by Nathan Condell on 1/3/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class Event: NSObject {
    
    var details: String?
    var endDate: Date
    var location: String?
    var startDate: Date
    var subtitle: String?
    var time: String?
    var title: String
    var createdAt: Date
    var updatedAt: Date
//    var day: Day
//    var note: Note
//    var papers: [Paper]
    
    convenience init(startDate: Date, endDate: Date, title: String, createdAt: Date, updatedAt: Date) {
        
        self.init(startDate: startDate, endDate: endDate, title: title)
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(startDate: Date, endDate: Date, title: String) {
        
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
