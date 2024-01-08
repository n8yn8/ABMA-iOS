//
//  ScheduleView.swift
//  ABMA
//
//  Created by Nate Condell on 1/7/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    
    var days: [Day]
    
    var body: some View {
        HStack {
            Button {
                print("back")
            } label: {
                Image("ArrowLeft")
            }
            .padding()
            
            Spacer()
            
            //TODO: UTC time
            Text(days.first?.date?.formatted(date: .abbreviated, time: .omitted) ?? "")
            
            Spacer()
            
            Button {
                print("forward")
            } label: {
                Image("ArrowRight")
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity)
        .background { Color.gray }
        
        List {
            ForEach(
                days.first?.event?
                    .sorted(by: { first, second in
                        first.startDate! < second.startDate!
                    }) ?? [],
                id: \.self
            ) { event in
                VStack(alignment: .leading) {
                    Text(event.title ?? "")
                    HStack {
                        Image("TimeIcon")
                        Text(Utils.timeFrame(startDate: event.startDate!, endDate: event.endDate))
                    }
                }
            }
        }
    }
}

#Preview {
    ScheduleView(days: [SampleData.day()])
}

struct SampleData {
    static let day = {
        let day = Day()
        day.date = Date()
        return day
    }
}
