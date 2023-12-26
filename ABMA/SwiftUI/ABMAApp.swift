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
//        DbManager.sharedInstance.getPublishedYears(since: nil) { years, errorString in
//            years?.forEach({ item in
//                let newItem = Year(context: viewContext)
//                newItem.year = "\(item.name)"
//                newItem.welcome = item.welcome
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
