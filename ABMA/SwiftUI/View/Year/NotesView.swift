//
//  NotesView.swift
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    
    var isLoggedIn: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.created, order: .reverse)]
    )
    private var items: FetchedResults<Note>
    
    var body: some View {
        BannerView(title: "Notes")
        
        if !isLoggedIn {
            LoginView(isLoggedIn: isLoggedIn)
        }
        
        List {
            ForEach(items, id: \.self) { note in
                NavigationLink {
                    if note.paper != nil {
                        PaperView(paper: note.paper!)
                    } else if note.event != nil {
                        EventView(event: note.event!)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.paper?.title ?? note.event?.title ?? "")
                            .font(.headline)
                        Text(note.content ?? "")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

//#Preview {
//    NotesView(isLoggedIn: )
//}
