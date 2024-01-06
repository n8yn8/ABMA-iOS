//
//  SponsorsView.swift
//  ABMA
//
//  Created by Nate Condell on 12/28/23.
//  Copyright © 2023 Nathan Condell. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SponsorsView: View {
    
    var sponsors: [Sponsor]
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        BannerView(title: "Sponsors")
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(sponsors, id: \.self) { sponsor in
                    WebImage(url: URL(string: sponsor.imageUrl ?? ""))
                        .onFailure { error in
                            print("error loading \(String(describing: sponsor.imageUrl)) error \(error)")
                        }
                        .resizable()
                        .placeholder(Image("ABMA-logo"))
                        .indicator(.activity)
                        .scaledToFit()
                }
            }
            .padding()
        }
        
    }

}

//#Preview {
//    SponsorsView(sponsors: [Sponsor()])
//}
