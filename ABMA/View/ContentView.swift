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
    
    @State private var isInitialView: Bool = true
    
    @StateObject private var dbManager = BackendlessManager.sharedInstance
    
    private enum Destinations: String, CaseIterable {
        case Welcome, Schedule, Notes, Info, Maps, Sponsors, Contact
    }
    
    var body: some View {
        NavigationStack {
            Image("ABMA-transparent")
                .resizable()
                .frame(width: 150, height: 150)
            
            List {
                ForEach(Destinations.allCases, id: \.rawValue) { destination in
                    NavigationLink(destination.rawValue, value: destination)
                }
                
                if dbManager.isUserLoggedIn {
                    Button("Logout") {
                        BackendlessManager.sharedInstance.logout { error in
                            print("Error logging out \(String(describing: error))")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isInitialView, destination: {
                scheduleView()
            })
            .navigationDestination(for: Destinations.self) { destination in
                switch destination {
                case .Welcome:
                    GeneralView(title: "Welcome", text: items.first?.welcome)
                case .Schedule:
                    scheduleView()
                case .Notes:
                    NotesView(isLoggedIn: dbManager.isUserLoggedIn)
                        .environment(\.managedObjectContext, viewContext)
                case .Info:
                    GeneralView(title: "Info", text: items.first?.info)
                case .Maps:
                    let maps = items.first?.maps?.allObjects as? [Map] ?? []
                    MapsView(maps: maps.map({ $0 }))
                case .Sponsors:
                    let sponsors = items.first?.sponsors?.allObjects as? [Sponsor] ?? []
                    SponsorsView(sponsors: sponsors.map({ $0 }))
                case .Contact:
                    let now = Date()
                    let surveys = items.first?.surveys?.allObjects as? [Survey] ?? []
                    ContactView(
                        surveys: surveys.filter({
                            let surveyStart = $0.start ?? Date()
                            let surveyEnd = $0.end ?? Date()
                            return now.timeIntervalSince1970 > surveyStart.timeIntervalSince1970 &&
                            now.timeIntervalSince1970 < surveyEnd.timeIntervalSince1970
                        })
                    )
                }
            }
        }.onAppear {
            isInitialView = true
            if (items.count == 0) {
                Utils.load(viewContext: viewContext)
            }
        }
    }
    
    private func scheduleView() -> some View {
        let days = items.first?.day?.allObjects as? [Day] ?? []
        return ScheduleView(
            days: days.sorted(by: { first, second in
                first.date! < second.date!
            })
        )
        .environment(\.managedObjectContext, viewContext)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
