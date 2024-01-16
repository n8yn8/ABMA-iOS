//
//  NotesView.swift
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.created, order: .reverse)]
    )
    private var items: FetchedResults<Note>
    
    var body: some View {
        BannerView(title: "Notes")
        
        List {
            ForEach(items, id: \.self) { note in
                NavigationLink {
                    if note.event != nil {
                        EventView(event: note.event!)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.event?.title ?? "")
                        Text(note.content ?? "")
                    }
                }
            }
        }
    }
}

#Preview {
    NotesView()
}
