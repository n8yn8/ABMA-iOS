//
//  BSurvey.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 2/26/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

import Foundation

class BSurvey: NSObject, Codable {
    
    @objc var title: String?
    @objc var details: String?
    @objc var url: String?
    @objc var start: Date?
    @objc var end: Date?
    
    @objc
    func initWith(title: String, details: String, url: String, start: Date, end: Date) {
        self.title = title
        self.details = details
        self.url = url
        self.start = start
        self.end = end
    }
    
}
