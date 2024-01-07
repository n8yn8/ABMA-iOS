//
//  ContactView.swift
//  ABMA
//
//  Created by Nate Condell on 1/6/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct ContactView: View {
    
    var surveys: [Survey]
    
    var body: some View {
        BannerView(title: "Contact")
        List {
            Section("Surveys") {
                if surveys.count == 0 {
                    Text("No surveys currently available")
                }
                ForEach(surveys, id: \.self) { survey in
                    Link(destination: URL(string: survey.url!)!) {
                        VStack(alignment: .leading) {
                            Text(survey.title ?? "")
                            HStack {
                                Image("TimeIcon")
                                Text("Available until \(Utils.time(endDate: survey.end ?? Date()))")
                            }
                        }
                        
                    }
                }
            }
            Section("Links") {
                Link("ABMA Website", destination: URL(string: "https://www.theabma.org")!)
                Link("Contact ABMA", destination: URL(string: "https://theabma.org/contact/")!)
            }
        }
    }
}

#Preview {
    ContactView(surveys: [Survey()])
}
