//
//  BackendError.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 10/31/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}
