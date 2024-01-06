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
//                        // Replace this implementation with code to handle the error appropriately.
//                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                        let nsError = error as NSError
//                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                    }
//                }
//            })
//            
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
