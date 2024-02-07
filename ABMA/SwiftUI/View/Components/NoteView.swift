//
//  NoteView.swift
//  ABMA
//
//  Created by Nate Condell on 2/6/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct NoteView: View {
    @Binding var noteText: String
    
    var body: some View {
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

//#Preview {
//    NoteView()
//}
