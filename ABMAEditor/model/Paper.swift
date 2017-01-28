//
//  Paper.swift
//  ABMA
//
//  Created by Nathan Condell on 1/11/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class Paper: NSObject {
    
    var objectId: String?
    var title: String!
    var author: String!
    var abstract: String!
    var created: Date?
    var updated: Date?
    
    func initWith(title: String, author: String, abstract: String) {
        self.title = title
        self.author = author
        self.abstract = abstract
    }

}
