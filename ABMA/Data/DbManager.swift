//
//  DbManager.swift
//  ABMA
//
//  Created by Nathan Condell on 1/27/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation
import SwiftSDK

class DbManager: NSObject, ObservableObject {
    
    @Published var isUserLoggedIn: Bool = false
    
    @objc
    static let sharedInstance = DbManager()

    let APP_ID = "7D06F708-89FA-DD86-FF95-C51A10425A00" //Prod
//    let APP_ID = "76269ABA-AF2E-5901-FF61-99AB83F57700" //Test
    let SECRET_KEY = "5DB2DE1C-0AFF-9AD6-FF16-83C8AE9F1600" //Prod
//    let SECRET_KEY = "DB8C6226-658C-4EA7-B076-FC0A8C882BCE" //Test
    
    var backendless = Backendless.shared
    
    override init() {
        super.init()
        backendless.initApp(applicationId: APP_ID, apiKey: SECRET_KEY)
        backendless.userService.stayLoggedIn = true
        
        isUserLoggedIn = backendless.userService.currentUser != nil
    }
    
    @objc
    func registerUser(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        let user: BackendlessUser = BackendlessUser()
        user.email = email
        user.password = password
        backendless.userService.registerUser(user: user, responseHandler: { (response) in
            print("response: \(String(describing: response))")
            self.login(email: email, password: password, callback: callback)
        }) { (error) in
            print("error: \(String(describing: error))")
            if let message = error.message {
                callback(message)
            } else {
                callback(error.debugDescription)
            }
        }
    
    }
    
    @objc
    func login(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        backendless.userService.login(identity: email, password: password, responseHandler: { (user) in
            print("User logged in")
            self.isUserLoggedIn = true
            callback(nil)
        }) { (error) in
            print("Error \(error.debugDescription)")
            if let message = error.message {
                callback(message)
            } else {
                callback(error.debugDescription)
            }
        }
    }
    
    @objc
    func userPasswordRecovery(email: String, callback: @escaping (_ errorString: String?) -> Void) {
        backendless.userService.restorePassword(identity: email, responseHandler: {
            callback("Check your email to recover you password.")
        }) { (fault) in
            print(String(describing: fault))
            if let message = fault.message {
                callback(message)
            } else {
                callback(fault.debugDescription)
            }
        }
    }
    
    @objc
    func logout(callback: @escaping (_ errorString: String?) -> Void) {
        backendless.userService.logout(responseHandler: {
            self.isUserLoggedIn = false
            callback(nil)
        }) { (fault) in
            callback(fault.debugDescription)
        }
    }
    
    @objc
    func getCurrentUser() -> BackendlessUser? {
        return backendless.userService.currentUser
    }

    @objc
    func getPublishedYears(since: Date?, callback: @escaping (_ years: [BYear]?, _ errorString: String?) -> Void) {
        var query = "publishedAt is not null"
        if let s = since {
            query += " AND updated > \(Double((s.timeIntervalSince1970 * 1000.0).rounded()))"
        }
        getYears(query: query, callback: callback)
    }
    
    private func getYears(query: String, callback: @escaping (_ years: [BYear]?, _ errorString: String?) -> Void) {
        let dataQuery = DataQueryBuilder()
        dataQuery.whereClause = query
        
        backendless.data.of(BYear.self).find(queryBuilder: dataQuery, responseHandler: { (response) in
            print("response \(String(describing: response))")
            if let years = response as? [BYear] {
                callback(years, nil)
            } else {
                callback([BYear](), nil)
            }
        }, errorHandler: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func getSponsors(yearId: String, callback: @escaping (_ events: [BSponsor]?, _ errorString: String?) -> Void) {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder(entityClass: BSponsor.self, relationName: "sponsors")
        loadRelationsQueryBuilder.pageSize = 100
        
        backendless.data.of(BYear.self).loadRelations(objectId: yearId, queryBuilder: loadRelationsQueryBuilder, responseHandler: { (response) in
            if let sponsors = response as? [BSponsor] {
                callback(sponsors, nil)
            } else {
                callback([BSponsor](), nil)
            }
        }, errorHandler: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func getEvents(yearId: String, callback: @escaping (_ events: [BEvent]?, _ errorString: String?) -> Void) {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder(entityClass: BEvent.self, relationName: "events")
        loadRelationsQueryBuilder.pageSize = 100
        
        backendless.data.of(BYear.self).loadRelations(objectId: yearId, queryBuilder: loadRelationsQueryBuilder, responseHandler: { (response) in
            if let events = response as? [BEvent] {
                callback(events, nil)
            } else {
                callback([BEvent](), nil)
            }
        }, errorHandler: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func getPapers(eventId: String, callback: @escaping (_ papers: [BPaper]?, _ errorString: String?) -> Void) {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder(entityClass: BPaper.self, relationName: "papers")
        loadRelationsQueryBuilder.pageSize = 100
        
        backendless.data.of(BEvent.self).loadRelations(objectId: eventId, queryBuilder: loadRelationsQueryBuilder, responseHandler: { (response) in
            if let papers = response as? [BPaper] {
                callback(papers, nil)
            } else {
                callback([BPaper](), nil)
            }
        }, errorHandler: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    func update(note: BNote, callback: @escaping (_ savedNote: BNote?, _ errorString: String?) -> Void) {
        backendless.data.of(BNote.self).save(entity: note, responseHandler: { (response) in
            if let saved = response as? BNote {
                self.relate(note: saved, user: note.user, callback: callback)
            } else {
                callback(nil, nil)
            }
        }, errorHandler: { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        })
    }
    
    func relate(note: BNote, user: BackendlessUser, callback: @escaping (_ savedNote: BNote?, _ errorString: String?) -> Void) {
        backendless.data.of(BNote.self).addRelation(columnName: "user", parentObjectId: note.objectId!, childrenObjectIds: [user.objectId!], responseHandler: { (response) in
            callback(note, nil)
        }) { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        }
    }
    
    @objc
    func getNotes(callback: @escaping (_ years: [BNote]?, _ errorString: String?) -> Void) {
        guard let user = getCurrentUser() else {
            callback(nil, "User not logged in")
            return
        }
        let dataQuery = DataQueryBuilder()
        dataQuery.whereClause = "user.objectId = \'\(user.objectId!)\'"
        backendless.data.of(BNote.self).find(queryBuilder: dataQuery, responseHandler: { (response) in
            print("response \(String(describing: response))")
            if let notes = response as? [BNote] {
                callback(notes, nil)
            }
        }, errorHandler: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func registerForPush(tokenData: Data) {
        backendless.messaging.registerDevice(deviceToken: tokenData, responseHandler: { (response) in
            print("registerForPush response \(String(describing: response))")
        }, errorHandler: { (error) in
            print("registerForPush error: \(String(describing: error.message))")
        })
    }
    
}
