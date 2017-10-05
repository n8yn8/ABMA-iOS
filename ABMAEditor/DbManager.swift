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

    let APP_ID = "627F9018-4483-B50E-FFCA-0E42A1E33F00"
    let SECRET_KEY = "39CCEDB9-46FF-D20D-FF00-832690CDE400"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override init() {
        super.init()
        backendless?.initApp(APP_ID, apiKey: SECRET_KEY)
        backendless?.userService.setStayLoggedIn(true)
    }
    
    func registerUser(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        let user: BackendlessUser = BackendlessUser()
        user.email = email as NSString!
        user.password = password as NSString!
        backendless?.userService.register(user, response: { (response) in
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
        let dataQuery = DataQueryBuilder()
        
        if let q = query {
            dataQuery?.setWhereClause(q)
        }
        
        backendless?.persistenceService.find(BYear.ofClass(), queryBuilder: dataQuery, response: { (response) in
            print("response \(String(describing: response))")
            if let years = response as? [BYear] {
                callback(years, nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    func deleteEvent(event: BEvent) {
        deleteRelatedPapers(event: event) {
            self.backendless?.data.remove(BEvent.ofClass(), objectId: event.objectId, response: { (number) in
                print("delete ref: \(String(describing: number))")
            }, error: { (error) in
                print("\(error.debugDescription)")
            })
        }
    }
    
    func deleteRelatedPapers(event: BEvent, callback: @escaping () -> Void) {
        for paper in event.papers {
            deletePaper(paper: paper)
        }
        callback() //TODO: put callback in last response
    }
    
    func deletePaper(paper: BPaper) {
        backendless?.data.remove(paper, response: { (ref) in
            print("delete ref: \(String(describing: ref))")
        }, error: { (error) in
            print("\(error.debugDescription)")
        })
    }
    
    func uploadImage(name: String, image: NSData, callback: @escaping (_ imageUrl: String) -> Void) {
        backendless?.file.saveFile("sponsors", fileName: name, content: image as Data!, response: { (saved) in
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
        let dataQuery = DataQueryBuilder()
        dataQuery?.setWhereClause("user.objectId = \'\(user.objectId!)\'")
        backendless?.persistenceService.find(BNote.ofClass(), queryBuilder: dataQuery, response: { (response) in
            print("response \(String(describing: response))")
            if let notes = response as? [BNote] {
                callback(notes, nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    func registerForPush(tokenData: Data) {
        backendless?.messaging.registerDevice(tokenData, response: { (response) in
            print("response \(String(describing: response))")
        }, error: { (error) in
            print("error: \(String(describing: error?.message))")
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
