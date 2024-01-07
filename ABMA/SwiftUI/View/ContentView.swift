//
//  ContentView.swift
//  ABMA
//
//  Created by Nate Condell on 12/22/23.
//  Copyright © 2023 Nathan Condell. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.year, order: .reverse)]
    )
    private var items: FetchedResults<Year>
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    GeneralView(title: "Welcome", text: items.first?.welcome)
                } label: {
                    Text("Welcome")
                }
                
                NavigationLink {
                    Text("Schedule")
                } label: {
                    Text("Schedule")
                }
                
                NavigationLink {
                    Text("Notes")
                } label: {
                    Text("Notes")
                }
                
                NavigationLink {
                    GeneralView(title: "Info", text: items.first?.info)
                } label: {
                    Text("Info")
                }
                
                NavigationLink {
                    MapsView(maps: items.first?.maps?.map({ $0 }) ?? [])
                } label: {
                    Text("Maps")
                }
                
                NavigationLink {
                    SponsorsView(sponsors: items.first?.sponsors?.map({ $0 }) ?? [])
                } label: {
                    Text("Sponsor")
                }
                
                NavigationLink {
                    let now = Date()
                    ContactView(
                        surveys: items.first?.surveys?.filter({ 
                            let surveyStart = $0.start ?? Date()
                            let surveyEnd = $0.end ?? Date()
                            return now.timeIntervalSince1970 > surveyStart.timeIntervalSince1970 && 
                            now.timeIntervalSince1970 < surveyEnd.timeIntervalSince1970
                        }) ?? []
                    )
                } label: {
                    Text("Contact")
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
