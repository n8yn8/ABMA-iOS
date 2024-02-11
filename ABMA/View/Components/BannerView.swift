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
                .frame(height: 80)
            Text(title)
                .font(.title)
                .foregroundColor(Color.white)
                
        }
    }
}

#Preview {
    BannerView(title: "Welcome")
}
