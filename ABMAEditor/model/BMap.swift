//
//  BMap.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 3/31/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

import Foundation

class BMap: NSObject, Codable {
    
    @objc var title = ""
    @objc var url: String?
    
    @objc
    func initWith(title: String, url: String) {
        self.title = title
        self.url = url
    }
    
}
