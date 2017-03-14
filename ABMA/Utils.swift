//
//  Utils.swift
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class Utils: NSObject {
    static func timeFrame(startDate: Date, endDate: Date?) -> String {
        let timeZone = TimeZone(abbreviation: "UTC")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.timeZone = timeZone
        var value = dateFormatter.string(from: startDate)
        if let end = endDate {
            value += " - \(dateFormatter.string(from: end))"
        }
        return value
    }
    
    static func save(note: Note, context: NSManagedObjectContext) {
        
        let user = DbManager.sharedInstance.getCurrentUser()
        if let user = user {
            let bNote = BNote();
            bNote.objectId = note.bObjectId;
            bNote.user = user;
            if let paper = note.paper {
                bNote.paperId = paper.bObjectId
                bNote.eventId = paper.event?.bObjectId
            } else {
                bNote.eventId = note.event?.bObjectId
            }
            bNote.content = note.content
            
            DbManager.sharedInstance.update(note: bNote) { (savedNote, error) in
                if let error = error {
                    print("Error: \(error)");
                } else {
                    note.bObjectId = savedNote?.objectId
                    note.created = savedNote?.created
                    note.updated = savedNote?.updated
                    save(context: context)
                }
            }
        } else {
            note.created = Date()
            save(context: context)
        }
        
    }
    
    static func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
