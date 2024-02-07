//
//  TitleView.swift
//  ABMA
//
//  Created by Nate Condell on 2/6/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    let title: String?
    let subtitle: String?
    
    var body: some View {
        HStack(alignment: .top) {
            Image("ABMA-transparent")
              .resizable()
              .frame(width: 70, height: 70)
              .background(Color.white)
              .clipShape(Circle())
              .overlay(Circle().stroke(Color.black, lineWidth: 1))
            
            VStack(content: {
                Text(title ?? "")
                Text(subtitle ?? "")
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
    }
}

//#Preview {
//    TitleView()
//}
