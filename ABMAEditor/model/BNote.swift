//
//  BNote.swift
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation
import Backendless

class BNote: NSObject {
    
    @objc var objectId: String?
    @objc var content: String?
    @objc var paperId: String?
    @objc var eventId: String?
    @objc var user: BackendlessUser!
    @objc var updated: Date?
    @objc var created: Date?
    
}
