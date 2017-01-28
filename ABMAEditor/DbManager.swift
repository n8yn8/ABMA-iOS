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
    
    func registerUser(email: String, password: String) {
        let user: BackendlessUser = BackendlessUser()
        user.email = email as NSString!
        user.password = password as NSString!
        backendless?.userService.registering(user, response: { (response) in
            print("response: \(response)")
        }, error: { (error) in
            print("error: \(error)")
        })
    }
    
    func updateEvent(event: Event, callback: @escaping (_ savedEvent: Event?, _ errorString: String?) -> Void) {
        backendless?.persistenceService.of(Event.ofClass()).save(event, response: { (response) in
            if let savedEvent = response as? Event {
                callback(savedEvent, nil)
            }
            callback(nil, nil)
        }, error: { (error) in
            print("error: \(error)")
            callback(nil, error.debugDescription)
        })
    }
    
    func getEvents(callback: @escaping (_ events: [Event]?, _ errorString: String?) -> Void) {
        let dataQuery = BackendlessDataQuery()
        
        backendless?.persistenceService.find(Event.ofClass(), dataQuery: dataQuery, response: { (response) in
            print("response \(response)")
            if let events = response?.data as? [Event] {
                callback(events, nil)
            }
        }, error: { (error) in
            print("error: \(error)")
            callback(nil, error.debugDescription)
        })
    }
    
    func deleteEvent(event: Event) {
        deleteRelatedPapers(event: event) { 
            self.backendless?.data.remove(Event.ofClass(), sid: event.objectId, response: { (ref) in
                print("delete ref: \(ref)")
            }, error: { (error) in
                print("\(error.debugDescription)")
            })

        }
    }
    
    func deleteRelatedPapers(event: Event, callback: @escaping () -> Void) {
        let query = BackendlessDataQuery()
        query.whereClause = "Event[papers].objectId = \'\(event.objectId!)\'"
        backendless?.data.removeAll(Paper.ofClass(), dataQuery: query, response: { (response) in
            print("response: \(response)")
            callback()
        }, error: { (error) in
            print("error: \(error.debugDescription)")
            callback()
        })
    }
    
    func deletePaper(paper: Paper) {
        backendless?.data.remove(paper, response: { (ref) in
            print("delete ref: \(ref)")
        }, error: { (error) in
            print("\(error.debugDescription)")
        })
    }
    
}
