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

    let APP_ID = "627F9018-4483-B50E-FFCA-0E42A1E33F00"
    let SECRET_KEY = "39CCEDB9-46FF-D20D-FF00-832690CDE400"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override init() {
        super.init()
        backendless?.initApp(APP_ID, apiKey: SECRET_KEY)
        backendless?.userService.setStayLoggedIn(true)
    }
    
    @objc
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
    
    @objc
    func logout(callback: @escaping (_ errorString: String?) -> Void) {
        backendless?.userService.logout({ (response) in
            callback(nil)
        }, error: { (error) in
            callback(error.debugDescription)
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
            print("response \(String(describing: response))")
        }, error: { (error) in
            print("error: \(String(describing: error?.message))")
        })
    }
    
}
