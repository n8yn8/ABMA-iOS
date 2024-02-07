//
//  EventDateView.swift
//  ABMA
//
//  Created by Nate Condell on 2/6/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct EventDateView: View {
    let event: Event
    
    var body: some View {
        HStack {
            //TODO: UTC time
            Text(event.startDate?.dayOfTheWeek().uppercased() ?? "")
            Text(event.startDate?.dateOfTheMonth() ?? "")
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background { Color.gray }
    }
}

//#Preview {
//    EventDateView()
//}
