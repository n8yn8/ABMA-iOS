//
//  AppDelegate.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 1/2/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa
import Firebase

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let defaults = NSUserDefaultsController.shared.defaults
        defaults.register(defaults: ["NSApplicationCrashOnExceptions" : true])
        FirebaseApp.configure()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

