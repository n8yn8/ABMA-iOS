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

class Utils {
    
    static func load(viewContext: NSManagedObjectContext) {
        let networkManager = BackendlessManager.sharedInstance
        
        let calendar = Calendar(identifier: .gregorian)
        
        let lastUpdated = getLastUpdated() ?? Date(timeIntervalSince1970: 1583635306) //default only get 2020
        
        networkManager.getPublishedYears(since: lastUpdated) { years, errorString in
            
            years?.forEach({ bYear in
                
                if let updated = bYear.updated ?? bYear.created {
                    updateLastUpdated(date: updated)
                }
                
                print("year \(bYear.name)")
                let year = Year(context: viewContext)
                year.year = "\(bYear.name)"
                year.welcome = bYear.welcome
                year.bObjectId = bYear.objectId
                year.info = bYear.info
                year.created = bYear.created;
                year.updatedAt = bYear.updated;
                
                Utils.getMapss(mapsString: bYear.maps)
                    .forEach { bMap in
                        let map = Map(context: viewContext)
                        map.title = bMap.title
                        map.url = bMap.url
                        year.addToMaps(map)
                    }
                
                Utils.getSurveys(surveysString: bYear.surveys)
                    .forEach { bSurvey in
                        let survey = Survey(context: viewContext)
                        survey.title = bSurvey.title
                        survey.details = bSurvey.details
                        survey.url = bSurvey.url
                        survey.start = bSurvey.start
                        survey.end = bSurvey.end
                        year.addToSurveys(survey)
                    }
                
                networkManager.getEvents(yearId: bYear.objectId!) { bEvents, errorString in
                    bEvents?.forEach({ bEvent in
                        let days = year.day?.allObjects as? [Day]
                        let day = days?.first(where: { day in
                            calendar.isDate(bEvent.startDate!, inSameDayAs: day.date!)
                        }) ?? {
                            let newDay = Day(context: viewContext)
                            newDay.date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: bEvent.startDate!))
                            year.addToDay(newDay)
                            return newDay
                        }()
                        
                        let event = Event(context: viewContext)
                        event.bObjectId = bEvent.objectId
                        event.title = bEvent.title
                        event.subtitle = bEvent.subtitle
                        event.locatoin = bEvent.location
                        event.startDate = bEvent.startDate
                        event.endDate = bEvent.endDate
                        event.details = bEvent.details
                        event.created = bEvent.created
                        event.updatedAt = bEvent.updated
                        
                        day.addToEvent(event)
                        
                        if bEvent.papersCount > 0 {
                            networkManager.getPapers(eventId: bEvent.objectId!) { bPapers, errorString in
                                bPapers?.sorted(by: { first, second in
                                    first.order > second.order
                                })
                                .forEach({ bPaper in
                                    let paper = Paper(context: viewContext)
                                    paper.bObjectId = bPaper.objectId
                                    paper.author = bPaper.author
                                    paper.title = bPaper.title
                                    paper.abstract = bPaper.synopsis
                                    paper.event = event
                                    paper.created = bPaper.created
                                    paper.updatedAt = bPaper.updated
                                    
                                    event.addToPapers(paper)
                                })
                                
                                do {
                                    try viewContext.save()
                                } catch {
                                    let nsError = error as NSError
                                    print("Save papers unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }
                        }
                    })
                    
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        print("Save events unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
                
                networkManager.getSponsors(yearId: bYear.objectId!) { sponsors, errorString in
                    sponsors?.forEach({ bSponsor in
                        let sponsor = Sponsor(context: viewContext)
                        sponsor.bObjectId = bSponsor.objectId
                        sponsor.url = bSponsor.url
                        sponsor.imageUrl = bSponsor.imageUrl
                        sponsor.created = bSponsor.created
                        sponsor.updatedAt = bSponsor.updated
                        sponsor.year = year
                        year.addToSponsors(sponsor)
                    })
                    
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            })
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
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
    
    static func time(endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: endDate)
    }
    
    static func save(note: Note, context: NSManagedObjectContext) {
        
        let user = BackendlessManager.sharedInstance.getCurrentUser()
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
            
            BackendlessManager.sharedInstance.update(note: bNote) { (savedNote, error) in
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
    
    static func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private static let LAST_UPDATED = "lastUpdated"
    
    private static func getLastUpdated() -> Date? {
        let date = UserDefaults.standard.object(forKey: LAST_UPDATED) as? Date
        return date
    }
    
    private static func updateLastUpdated(date: Date) {
        let prevUpdated = getLastUpdated()
        if let prev = prevUpdated {
            if date.timeIntervalSince1970 > prev.timeIntervalSince1970 {
                saveLastUpdated(date: date)
            }
        } else {
            saveLastUpdated(date: date)
        }
    }
    
    private static func saveLastUpdated(date: Date) {
        UserDefaults.standard.set(date, forKey: LAST_UPDATED)
    }
    
    static func handleError(method: String, message: String) {
        Analytics.logEvent("Error", parameters: ["method": method, "message": message])
        print("Error \(method) \(message)")
    }
    
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
