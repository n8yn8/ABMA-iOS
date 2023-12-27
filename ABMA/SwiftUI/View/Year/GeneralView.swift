//
//  WelcomeView.swift
//  ABMA
//
//  Created by Nate Condell on 12/22/23.
//  Copyright © 2023 Nathan Condell. All rights reserved.
//

import SwiftUI

struct GeneralView: View {
    var title: String
    var text: String?
    
    var body: some View {
        BannerView(title: title)
        
        ScrollView {
            Text(LocalizedStringKey(text ?? ""))
                .lineLimit(nil)
                .padding()
        }
    }
}

#Preview {
    GeneralView(title: "Welcome", text: "Welcome to the stuff")
}
