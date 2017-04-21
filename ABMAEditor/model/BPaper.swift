//
//  BPaper.swift
//  ABMA
//
//  Created by Nathan Condell on 1/11/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class BPaper: NSObject {
    
    var objectId: String?
    var title: String!
    var author: String!
    var synopsis: String!
    var upadted: Date?
    var created: Date?
    var order = 0
    
    func initWith(title: String, author: String, synopsis: String, order: Int) {
        self.title = title
        self.author = author
        self.synopsis = synopsis
        self.order = order
    }

}
