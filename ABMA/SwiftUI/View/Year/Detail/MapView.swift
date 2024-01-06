//
//  MapView.swift
//  ABMA
//
//  Created by Nate Condell on 1/6/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MapView: View {
    let map: Map
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        WebImage(url: URL(string: map.url ?? ""))
            .onFailure { error in
                print("error loading \(String(describing: map.url)) error \(error)")
            }
            .resizable()
            .placeholder(Image("ABMA-logo"))
            .indicator(.activity)
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        self.scale = value.magnitude
                    }
            )
            .navigationTitle(map.title ?? "")
    }
}

//#Preview {
//    MapView()
//}
