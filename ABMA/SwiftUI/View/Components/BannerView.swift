//
//  BannerView.swift
//  ABMA
//
//  Created by Nate Condell on 12/28/23.
//  Copyright © 2023 Nathan Condell. All rights reserved.
//

import SwiftUI

struct BannerView: View {
    var title: String
    
    var body: some View {
        ZStack {
            Color.gray
                .frame(height: 100)
            Text(title)
        }
    }
}

#Preview {
    BannerView(title: "Welcome")
}
