//
//  DbManager.swift
//  ABMA
//
//  Created by Nathan Condell on 1/27/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class DbManager {
    
    static let sharedInstance = DbManager()

    let APP_ID = "4F90A91F-3E58-5E4D-FF43-A0BA7FE1D500"
    let SECRET_KEY = "98A23A0E-4700-A4F9-FF98-4D2357390900"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    init() {
        backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    }
    
}
