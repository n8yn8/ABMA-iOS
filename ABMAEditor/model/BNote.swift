//
//  BNote.swift
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class BNote: NSObject {
    
    var objectId: String?
    var content: String?
    var paperId: String?
    var eventId: String?
    var user: BackendlessUser!
    var updated: Date?
    var created: Date?
    
}
