//
//  WelcomeView.swift
//  ABMA
//
//  Created by Nate Condell on 12/22/23.
//  Copyright © 2023 Nathan Condell. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var welcomeText: String?
    
    var body: some View {
        Text(welcomeText ?? "")
    }
}

#Preview {
    WelcomeView(welcomeText: "Welcome to the stuff")
}
