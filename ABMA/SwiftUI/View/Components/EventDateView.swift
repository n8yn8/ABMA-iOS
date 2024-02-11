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
                .font(.title3)
            Text(event.startDate?.dateOfTheMonth() ?? "")
                .font(.title)
            Spacer()
        }
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background { Color.gray }
    }
}

//#Preview {
//    EventDateView(event: Event())
//}
//
//struct EventSampleData {
//    static let evemt = {
//        let event = Event()
//        event.startDate = Date()
//        return event
//    }
//}

