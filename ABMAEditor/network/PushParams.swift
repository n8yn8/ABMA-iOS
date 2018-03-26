//
//  BackendError.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 10/31/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

struct PushParams: Codable {
    var message: String
    var pushPolicy: String
    var headers: PushHeaders
}

struct PushHeaders: Codable {
    var androidTitle: String
    var androidText: String
    var iosTitle: String
    var iosText: String
    var iosContentAvail: String
    
    enum CodingKeys: String, CodingKey {
        case androidTitle = "android-content-title"
        case androidText = "android-content-text"
        case iosTitle = "ios-alert-title"
        case iosText = "ios-alert-body"
        case iosContentAvail = "ios-content-available"
    }
}
