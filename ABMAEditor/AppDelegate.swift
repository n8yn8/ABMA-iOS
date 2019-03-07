//
//  AppDelegate.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 1/2/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa
import Fabric
import Crashlytics

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let defaults = NSUserDefaultsController.shared.defaults
        defaults.register(defaults: ["NSApplicationCrashOnExceptions" : true])
        Fabric.with([Crashlytics.self])
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

