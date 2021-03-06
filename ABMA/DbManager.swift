//
//  DbManager.swift
//  ABMA
//
//  Created by Nathan Condell on 1/27/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class DbManager: NSObject {
    
    @objc
    static let sharedInstance = DbManager()

    let APP_ID = "7D06F708-89FA-DD86-FF95-C51A10425A00" //Prod
//    let APP_ID = "05CFD853-3BFF-40F5-BAD0-E9CE8FA56630" //Test
    let SECRET_KEY = "5DB2DE1C-0AFF-9AD6-FF16-83C8AE9F1600" //Both
    
    var backendless = Backendless.sharedInstance()
    
    override init() {
        super.init()
        backendless?.initApp(APP_ID, apiKey: SECRET_KEY)
        backendless?.userService.setStayLoggedIn(true)
    }
    
    @objc
    func registerUser(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        let user: BackendlessUser = BackendlessUser()
        user.email = email as NSString
        user.password = password as NSString
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
    
    @objc
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
    
    @objc
    func userPasswordRecovery(email: String, callback: @escaping (_ errorString: String?) -> Void) {
        backendless?.userService?.restorePassword(email, response: {
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
    
    @objc
    func logout(callback: @escaping (_ errorString: String?) -> Void) {
        backendless?.userService.logout({
            callback(nil)
        }, error: { (fault) in
            callback(fault.debugDescription)
        })
    }
    
    @objc
    func getCurrentUser() -> BackendlessUser? {
        return backendless?.userService.currentUser
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
        let dataQuery = DataQueryBuilder().setWhereClause(query)
        
        backendless?.persistenceService.find(BYear.ofClass(), queryBuilder: dataQuery, response: { (response) in
            print("response \(String(describing: response))")
            if let years = response as? [BYear] {
                callback(years, nil)
            } else {
                callback([BYear](), nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func getSponsors(yearId: String, callback: @escaping (_ events: [BSponsor]?, _ errorString: String?) -> Void) {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder.of(BSponsor.ofClass())
            .setRelationName("sponsors")
            .setPageSize(100)
        
        backendless?.data.of(BYear.ofClass()).loadRelations(yearId, queryBuilder: loadRelationsQueryBuilder, response: { (response) in
            if let sponsors = response as? [BSponsor] {
                callback(sponsors, nil)
            } else {
                callback([BSponsor](), nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func getEvents(yearId: String, callback: @escaping (_ events: [BEvent]?, _ errorString: String?) -> Void) {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder.of(BEvent.ofClass())
            .setRelationName("events")
            .setPageSize(100)
        
        backendless?.data.of(BYear.ofClass()).loadRelations(yearId, queryBuilder: loadRelationsQueryBuilder, response: { (response) in
            if let events = response as? [BEvent] {
                callback(events, nil)
            } else {
                callback([BEvent](), nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func getPapers(eventId: String, callback: @escaping (_ papers: [BPaper]?, _ errorString: String?) -> Void) {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder.of(BPaper.ofClass())
            .setRelationName("papers")
            .setPageSize(100)
        
        backendless?.data.of(BEvent.ofClass()).loadRelations(eventId, queryBuilder: loadRelationsQueryBuilder, response: { (response) in
            if let papers = response as? [BPaper] {
                callback(papers, nil)
            } else {
                callback([BPaper](), nil)
            }
        }, error: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error.debugDescription)
        })
    }
    
    func update(note: BNote, callback: @escaping (_ savedNote: BNote?, _ errorString: String?) -> Void) {
        backendless?.data.of(BNote.ofClass()).save(note, response: { (response) in
            if let saved = response as? BNote {
                self.relate(note: saved, user: note.user, callback: callback)
            } else {
                callback(nil, nil)
            }
        }, error: { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        })
    }
    
    func relate(note: BNote, user: BackendlessUser, callback: @escaping (_ savedNote: BNote?, _ errorString: String?) -> Void) {
        guard  let dataStore = backendless?.data.of(BNote.ofClass()) else {
            callback(note, nil)
            return
        }
        dataStore.addRelation("user", parentObjectId: note.objectId, childObjects: [user.objectId as String], response: { (response) in
            callback(note, nil)
        }, error: { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        })
    }
    
    @objc
    func getNotes(callback: @escaping (_ years: [BNote]?, _ errorString: String?) -> Void) {
        guard let user = getCurrentUser() else {
            callback(nil, "User not logged in")
            return
        }
        let dataQuery = DataQueryBuilder().setWhereClause("user.objectId = \'\(user.objectId!)\'")
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
    
    @objc
    func registerForPush(tokenData: Data) {
        backendless?.messaging.registerDevice(tokenData, response: { (response) in
            print("registerForPush response \(String(describing: response))")
        }, error: { (error) in
            print("registerForPush error: \(String(describing: error?.message))")
        })
    }
    
}
