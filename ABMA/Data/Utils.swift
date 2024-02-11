//
//  Utils.swift
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class Utils: NSObject {
    
    @objc
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
    
    @objc
    static func time(endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: endDate)
    }
    
    @objc
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
                    note.updatedAt = savedNote?.updated
                    save(context: context)
                }
            }
        } else {
            note.created = Date()
            save(context: context)
        }
        
    }
    
    @objc
    static func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static let LAST_UPDATED = "lastUpdated"
    
    @objc
    static func getLastUpdated() -> Date? {
        let date = UserDefaults.standard.object(forKey: LAST_UPDATED) as? Date
        return date
    }
    
    @objc
    static func updateLastUpdated(date: Date) {
        let prevUpdated = getLastUpdated()
        if let prev = prevUpdated {
            if date.timeIntervalSince1970 > prev.timeIntervalSince1970 {
                saveLastUpdated(date: date)
            }
        } else {
            saveLastUpdated(date: date)
        }
    }
    
    @objc
    private static func saveLastUpdated(date: Date) {
        UserDefaults.standard.set(date, forKey: LAST_UPDATED)
    }
    
    @objc
    static func handleError(method: String, message: String) {
        Analytics.logEvent("Error", parameters: ["method": method, "message": message])
        print("Error \(method) \(message)")
    }
    
    @objc
    static func getSurveys(surveysString: String?) -> [BSurvey] {
        var surveys = [BSurvey]()
        if let string = surveysString {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                surveys = try decoder.decode([BSurvey].self, from: string.data(using: .utf8)!)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                surveys = [BSurvey]()
            }
        } else {
            surveys = [BSurvey]()
        }
        return surveys
    }
    
    @objc
    static func getMapss(mapsString: String?) -> [BMap] {
        var maps = [BMap]()
        if let string = mapsString {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                maps = try decoder.decode([BMap].self, from: string.data(using: .utf8)!)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                maps = [BMap]()
            }
        } else {
            maps = [BMap]()
        }
        return maps
    }
}
