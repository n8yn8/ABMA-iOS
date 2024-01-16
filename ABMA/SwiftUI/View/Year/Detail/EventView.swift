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
        HStack {
            //TODO: UTC time
            Text(event.startDate?.dayOfTheWeek().uppercased() ?? "")
            Text(event.startDate?.dateOfTheMonth() ?? "")
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background { Color.gray }
        .toolbar {
            Button("Note") {
                showingNote.toggle()
            }
            .sheet(isPresented: $showingNote) {
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
                VStack() {
                    Text("Note")
                        .padding()
                    TextField(text: $noteText, axis: .vertical) {
                        Text("Note")
                    }
                    .padding()
                    Spacer()
                }
                .presentationDetents([.medium])
            }
        }
        
        HStack(alignment: .top) {
            Image("ABMA-transparent")
              .resizable()
              .frame(width: 70, height: 70)
              .background(Color.white)
              .clipShape(Circle())
              .overlay(Circle().stroke(Color.black, lineWidth: 1))
            
            VStack(content: {
                Text(event.title ?? "")
                Text(event.subtitle ?? "")
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        
        HStack(alignment: .firstTextBaseline) {
            Image("PlaceIcon")
            Text(event.locatoin ?? "")
            Spacer()
            Image("TimeIcon")
            Text(Utils.timeFrame(startDate: event.startDate ?? Date(), endDate: event.endDate))
        }
        .padding(4)
        .background(Color(red: 224/255, green: 224/255, blue: 224/255))
        
        if event.papers == nil {
            ScrollView {
                Text(event.details ?? "")
            }
        } else {
            List {
                ForEach(event.papers?.map({ $0 }) ?? [], id: \.self) { paper in
                    VStack {
                        Text(paper.title ?? "")
                        Text(paper.author ?? "")
                    }
                }
            }
            
        }
        
        
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func dateOfTheMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
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
