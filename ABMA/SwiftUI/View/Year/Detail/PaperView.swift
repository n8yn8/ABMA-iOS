//
//  PaperView.swift
//  ABMA
//
//  Created by Nate Condell on 2/4/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct PaperView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let paper: Paper
    
    @State private var showingNote = false
    @State private var noteText = ""
    
    var body: some View {
        EventDateView(event: paper.event!)
            .toolbar {
                Button("Note") {
                    showingNote.toggle()
                }
                .sheet(isPresented: $showingNote) {
                    //TODO: abstract to mirror event?
                    if noteText == "" {
                        guard let note = paper.note else { return }
                        viewContext.delete(note)
                    } else {
                        if paper.note == nil {
                            paper.note = Note(context: viewContext)
                            paper.note?.created = Date()
                        }
                        paper.note?.content = noteText
                        paper.note?.updated = Date()
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
        
        TitleView(title: paper.title, subtitle: paper.author)
        
        EventPlaceTimeView(event: paper.event!)
        
        ScrollView {
            Text(paper.abstract ?? "")
                .padding()
        }
    }
}

//#Preview {
//    PaperView()
//}
