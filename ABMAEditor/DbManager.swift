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
        super.init()
        backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless?.userService.setStayLoggedIn(true)
    }
    
    func registerUser(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        let user: BackendlessUser = BackendlessUser()
        user.email = email as NSString!
        user.password = password as NSString!
        backendless?.userService.registering(user, response: { (response) in
            print("response: \(String(describing: response))")
            self.login(email: email, password: password, callback: callback)
        }, error: { (error) in
            print("error: \(String(describing: error))")
            if let message = error?.detail {
                callback(message)
            } else {
                callback(error.debugDescription)
            }
            
        })
    }
    
    func login(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        backendless?.userService.login(email, password: password, response: { (user) in
            print("User logged in")
            callback(nil)
        }, error: { (error) in
            print("Error \(error.debugDescription)")
            if let message = error?.detail {
                callback(message)
            } else {
                callback(error.debugDescription)
            }
        })
    }
    
    func userPasswordRecovery(email: String, callback: @escaping (_ errorString: String?) -> Void) {
        backendless?.userService.restorePassword(email, response: { (response) in
            print(String(describing: response))
            callback("Check your email to recover you password.")
        }, error: { (fault) in
            print(String(describing: fault))
            if let message = fault?.detail {
                callback(message)
            } else {
                callback(fault.debugDescription)
            }
        })
    }
    
    func logout(callback: @escaping (_ errorString: String?) -> Void) {
        backendless?.userService.logout({ (response) in
            callback(nil)
        }, error: { (error) in
            callback(error.debugDescription)
        })
    }
    
    func getCurrentUser() -> BackendlessUser? {
        return backendless?.userService.currentUser
    }
    
    func update(year: BYear, callback: @escaping (_ savedYear: BYear?, _ errorString: String?) -> Void) {
        backendless?.persistenceService.of(BYear.ofClass()).save(year, response: { (response) in
            if let saved = response as? BYear {
                callback(saved, nil)
            } else {
                callback(nil, nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
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
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    func getYears(callback: @escaping (_ years: [BYear]?, _ errorString: String?) -> Void) {
        getYears(query: nil, callback: callback)
    }

    func getPublishedYears(since: Date?, callback: @escaping (_ years: [BYear]?, _ errorString: String?) -> Void) {
        var query = "publishedAt is not null"
        if let s = since {
            query += " AND updated > \(Double((s.timeIntervalSince1970 * 1000.0).rounded()))"
        }
        getYears(query: query, callback: callback)
    }
    
    private func getYears(query: String?, callback: @escaping (_ years: [BYear]?, _ errorString: String?) -> Void) {
        let dataQuery = BackendlessDataQuery()
        
        if let q = query {
            dataQuery.whereClause = q
        }
        
        backendless?.persistenceService.find(BYear.ofClass(), dataQuery: dataQuery, response: { (response) in
            print("response \(String(describing: response))")
            if let years = response?.data as? [BYear] {
                callback(years, nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    func deleteEvent(event: BEvent) {
        deleteRelatedPapers(event: event) { 
            self.backendless?.data.remove(BEvent.ofClass(), sid: event.objectId, response: { (ref) in
                print("delete ref: \(String(describing: ref))")
            }, error: { (error) in
                print("\(error.debugDescription)")
            })

        }
    }
    
    func deleteRelatedPapers(event: BEvent, callback: @escaping () -> Void) {
        let query = BackendlessDataQuery()
        query.whereClause = "BEvent[papers].objectId = \'\(event.objectId!)\'"
        backendless?.data.removeAll(BPaper.ofClass(), dataQuery: query, response: { (response) in
            print("response: \(String(describing: response))")
            callback()
        }, error: { (error) in
            print("error: \(error.debugDescription)")
            callback()
        })
    }
    
    func deletePaper(paper: BPaper) {
        backendless?.data.remove(paper, response: { (ref) in
            print("delete ref: \(String(describing: ref))")
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
    
    func update(note: BNote, callback: @escaping (_ savedNote: BNote?, _ errorString: String?) -> Void) {
        backendless?.data.of(BNote.ofClass()).save(note, response: { (response) in
            if let saved = response as? BNote {
                callback(saved, nil)
            } else {
                callback(nil, nil)
            }
        }, error: { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        })
    }
    
    func getNotes(callback: @escaping (_ years: [BNote]?, _ errorString: String?) -> Void) {
        guard let user = getCurrentUser() else {
            callback(nil, "User not logged in")
            return
        }
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "user.objectId = \'\(user.objectId!)\'"
        backendless?.persistenceService.find(BNote.ofClass(), dataQuery: dataQuery, response: { (response) in
            print("response \(String(describing: response))")
            if let notes = response?.data as? [BNote] {
                callback(notes, nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    func registerForPush(tokenData: Data) {
        backendless?.messaging.registerDeviceToken(tokenData, response: { (response) in
            print("response \(String(describing: response))")
        }, error: { (fault) in
            print("error: \(String(describing: fault?.message))")
        })
    }
    
    func pushUpdate(message: String) {
        let publishOptions = PublishOptions()
        publishOptions.assignHeaders(["ios-text":message,
                                      "android-content-title":"ABMA",
                                      "android-content-text":message])
        backendless?.messaging.publish("default", message: message, response: { (messageStatus) in
            print("message status = \(String(describing: messageStatus?.status)) \(String(describing: messageStatus?.messageId))")
        }, error: { (fault) in
            print("Message fault \(String(describing: fault?.message))")
        })
    }
    
}
