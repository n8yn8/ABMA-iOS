//
//  ScheduleView.swift
//  ABMA
//
//  Created by Nate Condell on 1/7/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var days: [Day]
    
    @State private var index = 0
    @State private var selectedDay: Day?
    
    init(days: [Day]) {
        self.days = days
        _selectedDay = State(initialValue: days.first)
    }
    
    var body: some View {
        HStack {
            if index > 0 {
                Button {
                    index -= 1
                    selectedDay = days[index]
                } label: {
                    Image("ArrowLeft")
                }
                .padding()
            }
            
            Spacer()
            
            //TODO: UTC time
            Text(selectedDay?.date?.formatted(date: .abbreviated, time: .omitted) ?? "")
                .font(.title)
                .foregroundColor(Color.white)
            
            Spacer()
            
            if index < days.count - 1 {
                Button {
                    index += 1
                    selectedDay = days[index]
                } label: {
                    Image("ArrowRight")
                }
                .padding()
            }
            
            
        }
        .frame(maxWidth: .infinity)
        .background { Color.gray }
        
        List {
            ForEach(
                selectedDay?.event?
                    .sorted(by: { first, second in
                        first.startDate! < second.startDate!
                    }) ?? [],
                id: \.self
            ) { event in
                NavigationLink {
                    EventView(event: event)
                        .environment(\.managedObjectContext, viewContext)
                } label: {
                    VStack(alignment: .leading) {
                        Text(event.title ?? "")
                            .font(.headline)
                        HStack {
                            Image("TimeIcon")
                            Text(Utils.timeFrame(startDate: event.startDate!, endDate: event.endDate))
                                .font(.subheadline)
                        }
                    }
                }
                
            }
        }
    }
}

//#Preview {
//    ScheduleView(days: [SampleData.day()])
//}

struct SampleData {
    static let day = {
        let day = Day()
        day.date = Date()
        return day
    }
}
