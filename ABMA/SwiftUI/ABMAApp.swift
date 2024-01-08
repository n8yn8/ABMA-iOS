//
//  ABMAApp.swift
//  ABMA
//
//  Created by Nate Condell on 12/22/23.
//  Copyright © 2023 Nathan Condell. All rights reserved.
//

import SwiftUI

@main
struct ABMAApp: App {
    let persistenceController = PersistenceController.shared
    
//    init(){
//        let viewContext = persistenceController.container.viewContext
//        let networkManager = DbManager.sharedInstance
//        
//        let calendar = Calendar(identifier: .gregorian)
//        
//        networkManager.getPublishedYears(since: nil) { years, errorString in
//            years?.forEach({ bYear in
//                let year = Year(context: viewContext)
//                year.year = "\(bYear.name)"
//                year.welcome = bYear.welcome
//                year.bObjectId = bYear.objectId
//                year.info = bYear.info
//                year.created = bYear.created;
//                year.updated = bYear.updated;
//                
//                Utils.getMapss(mapsString: bYear.maps)
//                    .forEach { bMap in
//                        let map = Map(context: viewContext)
//                        map.title = bMap.title
//                        map.url = bMap.url
//                        year.addMapsObject(map)
//                    }
//                
//                Utils.getSurveys(surveysString: bYear.surveys)
//                    .forEach { bSurvey in
//                        let survey = Survey(context: viewContext)
//                        survey.title = bSurvey.title
//                        survey.details = bSurvey.details
//                        survey.url = bSurvey.url
//                        survey.start = bSurvey.start
//                        survey.end = bSurvey.end
//                        year.addSurveysObject(survey)
//                    }
//                
//                networkManager.getEvents(yearId: bYear.objectId!) { bEvents, errorString in
//                    bEvents?.forEach({ bEvent in
//                        let day = year.day?.first(where: { day in
//                            calendar.isDate(bEvent.startDate!, inSameDayAs: day.date!)
//                        }) ?? {
//                            let newDay = Day(context: viewContext)
//                            newDay.date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: bEvent.startDate!))
//                            year.addDayObject(newDay)
//                            return newDay
//                        }()
//                        
//                        let event = Event(context: viewContext)
//                        event.bObjectId = bEvent.objectId
//                        event.title = bEvent.title
//                        event.subtitle = bEvent.subtitle
//                        event.locatoin = bEvent.location
//                        event.startDate = bEvent.startDate
//                        event.endDate = bEvent.endDate
//                        event.details = bEvent.details
//                        event.created = bEvent.created
//                        event.updated = bEvent.updated
//                        
//                        day.addEventObject(event)
//                        
//                        if bEvent.papersCount > 0 {
//                            networkManager.getPapers(eventId: bEvent.objectId!) { bPapers, errorString in
//                                bPapers?.sorted(by: { first, second in
//                                    first.order > second.order
//                                })
//                                .forEach({ bPaper in
//                                    let paper = Paper(context: viewContext)
//                                    paper.bObjectId = bPaper.objectId
//                                    paper.author = bPaper.author
//                                    paper.title = bPaper.title
//                                    paper.abstract = bPaper.synopsis
//                                    paper.event = event
//                                    paper.created = bPaper.created
//                                    paper.updated = bPaper.updated
//                                    
//                                    event.addPapersObject(paper)
//                                })
//                                
//                                do {
//                                    try viewContext.save()
//                                } catch {
//                                    let nsError = error as NSError
//                                    print("Save papers unresolved error \(nsError), \(nsError.userInfo)")
//                                }
//                            }
//                        }
//                    })
//                    
//                    do {
//                        try viewContext.save()
//                    } catch {
//                        let nsError = error as NSError
//                        print("Save events unresolved error \(nsError), \(nsError.userInfo)")
//                    }
//                }
//                
//                networkManager.getSponsors(yearId: bYear.objectId!) { sponsors, errorString in
//                    sponsors?.forEach({ bSponsor in
//                        let sponsor = Sponsor(context: viewContext)
//                        sponsor.bObjectId = bSponsor.objectId
//                        sponsor.url = bSponsor.url
//                        sponsor.imageUrl = bSponsor.imageUrl
//                        sponsor.created = bSponsor.created
//                        sponsor.updated = bSponsor.updated
//                        sponsor.year = year
//                        year.addSponsorsObject(sponsor)
//                    })
//                    
//                    do {
//                        try viewContext.save()
//                    } catch {
//                        let nsError = error as NSError
//                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                    }
//                }
//            })
//            
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
