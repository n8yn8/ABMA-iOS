//
//  EventView.swift
//  ABMA
//
//  Created by Nate Condell on 1/14/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct EventView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var event: Event
    
    @State private var showingNote = false
    @State private var noteText = ""
    
    init(event: Event) {
        self.event = event
        _noteText = State(initialValue: event.note?.content ?? "")
    }
    
    var body: some View {
        EventDateView(event: event)
        .toolbar {
            Button("Note") {
                showingNote.toggle()
            }
            .sheet(isPresented: $showingNote) {
                //TODO: abstract to mirror paper?
                if noteText == "" {
                    guard let note = event.note else { return }
                    viewContext.delete(note)
                } else {
                    if event.note == nil {
                        event.note = Note(context: viewContext)
                        event.note?.created = Date()
                    }
                    event.note?.content = noteText
                    event.note?.updated = Date()
                }
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    print("Save events unresolved error \(nsError), \(nsError.userInfo)")
                }
            } content: {
                NoteView(noteText: $noteText)
            }
        }
        
        TitleView(title: event.title, subtitle: event.subtitle)
        
        EventPlaceTimeView(event: event)
        
        if event.papers == nil {
            ScrollView {
                Text(event.details ?? "")
                    .padding()
            }
        } else {
            List {
                ForEach(event.papers?.map({ $0 }) ?? [], id: \.self) { paper in
                    NavigationLink {
                        PaperView(paper: paper)
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(paper.title ?? "")
                                .font(.headline)
                            Text(paper.author ?? "")
                                .font(.subheadline)
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
}

#Preview {
    EventView(event: SampleEventData.event())
}

struct SampleEventData {
    static let event = {
        let event = Event()
        event.startDate = Date()
        return event
    }
}
