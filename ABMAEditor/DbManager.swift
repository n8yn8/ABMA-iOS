//
//  DbManager.swift
//  ABMA
//
//  Created by Nathan Condell on 1/27/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class DbManager: NSObject {
    
    static let sharedInstance = DbManager()

    let APP_ID = "6AC37915-D986-26C2-FF1C-B0B3ACCB6A00"
    let SECRET_KEY = "8CAD138B-161D-CC78-FF65-B2B6B6A40500"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override init() {
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
    
    func update(year: BYear, callback: @escaping (_ savedYear: BYear?, _ errorString: String?) -> Void) {
        backendless?.persistenceService.of(BYear.ofClass()).save(year, response: { (response) in
            if let saved = response as? BYear {
                callback(saved, nil)
            } else {
                callback(nil, nil)
            }
        }, error: { (error) in
            print("error: \(error)")
            callback(nil, error.debugDescription)
        })
    }
    
    func updateEvent(event: BEvent, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        backendless?.persistenceService.of(BEvent.ofClass()).save(event, response: { (response) in
            if let savedEvent = response as? BEvent {
                callback(savedEvent, nil)
            } else {
                callback(nil, nil)
            }
        }, error: { (error) in
            print("error: \(error)")
            callback(nil, error.debugDescription)
        })
    }
    
    func getYears(callback: @escaping (_ years: [BYear]?, _ errorString: String?) -> Void) {
        let dataQuery = BackendlessDataQuery()
        
        backendless?.persistenceService.find(BYear.ofClass(), dataQuery: dataQuery, response: { (response) in
            print("response \(response)")
            if let years = response?.data as? [BYear] {
                callback(years, nil)
            }
        }, error: { (error) in
            print("error: \(error)")
            callback(nil, error.debugDescription)
        })
    }
    
    func deleteEvent(event: BEvent) {
        deleteRelatedPapers(event: event) { 
            self.backendless?.data.remove(BEvent.ofClass(), sid: event.objectId, response: { (ref) in
                print("delete ref: \(ref)")
            }, error: { (error) in
                print("\(error.debugDescription)")
            })

        }
    }
    
    func deleteRelatedPapers(event: BEvent, callback: @escaping () -> Void) {
        let query = BackendlessDataQuery()
        query.whereClause = "BEvent[papers].objectId = \'\(event.objectId!)\'"
        backendless?.data.removeAll(BPaper.ofClass(), dataQuery: query, response: { (response) in
            print("response: \(response)")
            callback()
        }, error: { (error) in
            print("error: \(error.debugDescription)")
            callback()
        })
    }
    
    func deletePaper(paper: BPaper) {
        backendless?.data.remove(paper, response: { (ref) in
            print("delete ref: \(ref)")
        }, error: { (error) in
            print("\(error.debugDescription)")
        })
    }
    
    func uploadImage(name: String, image: NSData, callback: @escaping (_ imageUrl: String) -> Void) {
        backendless?.file.upload("sponsors/\(name)", content: image as Data!, overwrite: true, response: { (saved) in
            if let file = saved {
                print("file uplodaed")
                callback(file.fileURL)
            }
        }, error: { (error) in
            print("error: \(error.debugDescription)")
        })
    }
    
}
