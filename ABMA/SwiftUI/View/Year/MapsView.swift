//
//  MapsView.swift
//  ABMA
//
//  Created by Nate Condell on 1/4/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MapsView: View {
    var maps: [Map]
    
    var body: some View {
        BannerView(title: "Maps")
        
        ScrollView {
            LazyVStack {
                ForEach(maps, id: \.self) { map in
                    
                    WebImage(url: URL(string: map.url ?? ""))
                        .onFailure { error in
                            print("error loading \(String(describing: map.url)) error \(error)")
                        }
                        .resizable()
                        .placeholder(Image("ABMA-logo"))
                        .indicator(.activity)
                        .scaledToFill()
                        .overlay(alignment: .bottom) {
                            Text(map.title ?? "")
                                .padding()
                                .background(Color.gray.opacity(0.75),
                                            in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                .padding()
                        }
                    
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    MapsView()
//}
