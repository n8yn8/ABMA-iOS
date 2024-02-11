//
//  PlaceTimeView.swift
//  ABMA
//
//  Created by Nate Condell on 2/6/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct EventPlaceTimeView: View {
    let event: Event
    
    var body: some View {
        HStack(alignment: .center) {
            Image("PlaceIcon")
            Text(event.locatoin ?? "")
            Spacer()
            Image("TimeIcon")
            Text(Utils.timeFrame(startDate: event.startDate ?? Date(), endDate: event.endDate))
        }
        .font(.footnote)
        .padding(4)
        .background(Color(red: 224/255, green: 224/255, blue: 224/255))
    }
}

//#Preview {
//    PlaceTimeView()
//}
