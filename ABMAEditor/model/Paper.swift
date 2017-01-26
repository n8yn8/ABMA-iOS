//
//  Paper.swift
//  ABMA
//
//  Created by Nathan Condell on 1/11/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa

class Paper: NSObject {
    
    var title: String
    var author: String
    var abstract: String
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, author: String, abstract: String, createdAt: Date, updatedAt: Date) {
        self.title = title
        self.author = author
        self.abstract = abstract
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(title: String, author: String, abstract: String) {
        self.title = title
        self.author = author
        self.abstract = abstract
        self.createdAt = Date()
        self.updatedAt = Date()
    }

}
