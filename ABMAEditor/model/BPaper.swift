//
//  BPaper.swift
//  ABMA
//
//  Created by Nathan Condell on 1/11/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class BPaper: NSObject, Codable {
    
    @objc var objectId: String?
    @objc var title: String!
    @objc var author: String!
    @objc var synopsis: String!
    @objc var updated: Date?
    @objc var created: Date?
    @objc var order = 0
    
    @objc 
    func initWith(title: String, author: String, synopsis: String, order: Int) {
        self.title = title
        self.author = author
        self.synopsis = synopsis
        self.order = order
    }

}
