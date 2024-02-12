//
//  DbManager.swift
//  ABMA
//
//  Created by Nathan Condell on 1/27/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation
import SwiftSDK

class BackendlessManager: NSObject, ObservableObject {
    
    @Published var isUserLoggedIn: Bool = false
    
    static let sharedInstance = BackendlessManager()
    
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
    
    func registerUser(email: String, password: String) async throws -> BackendlessUser {
        let user: BackendlessUser = BackendlessUser()
        user.email = email
        user.password = password
        
        let _ = try await withCheckedThrowingContinuation { continuation in
            backendless.userService.registerUser(user: user, responseHandler: { (response) in
                print("response: \(String(describing: response))")
                continuation.resume(returning: user)
            }) { (error) in
                continuation.resume(throwing: error)
            }
        }
        
        return try await self.login(email: email, password: password)
        
    }
    
    func login(email: String, password: String) async throws -> BackendlessUser {
        return try await withCheckedThrowingContinuation { continuation in
            backendless.userService.login(identity: email, password: password, responseHandler: { (user) in
                print("User logged in")
                DispatchQueue.main.async {
                    self.isUserLoggedIn = true
                }
                continuation.resume(returning: user)
            }) { (error) in
                print("Error \(error.debugDescription)")
                continuation.resume(throwing: error)
            }
        }
        
        
    }
    
    func userPasswordRecovery(email: String) async throws {
        
        return try await withCheckedThrowingContinuation { continuation in
            backendless.userService.restorePassword(identity: email, responseHandler: {
                continuation.resume()
                //TODO: display "Check your email to recover you password."
            }) { (fault) in
                continuation.resume(throwing: fault)
            }
        }
    }
    
    func logout() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            backendless.userService.logout(responseHandler: {
                DispatchQueue.main.async {
                    self.isUserLoggedIn = false
                }
                continuation.resume()
            }) { (fault) in
                continuation.resume(throwing: fault)
            }
        }
    }
    
    func getCurrentUser() -> BackendlessUser? {
        return backendless.userService.currentUser
    }
    
    func getPublishedYears(since: Date?) async throws -> [BYear]? {
        var query = "publishedAt is not null"
        if let s = since {
            query += " AND updated > \(Double((s.timeIntervalSince1970 * 1000.0).rounded()))"
        }
        return try await getYears(query: query)
    }
    
    private func getYears(query: String) async throws -> [BYear]? {
        let dataQuery = DataQueryBuilder()
        dataQuery.whereClause = query
        
        return try await withCheckedThrowingContinuation { continuation in
            backendless.data.of(BYear.self).find(queryBuilder: dataQuery, responseHandler: { (response) in
                print("response \(String(describing: response))")
                let years = response as? [BYear] ?? []
                continuation.resume(returning: years)
            }, errorHandler: { (error) in
                continuation.resume(throwing: error)
            })
        }
        
    }
    
    func getSponsors(yearId: String) async throws -> [BSponsor]? {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder(entityClass: BSponsor.self, relationName: "sponsors")
        loadRelationsQueryBuilder.pageSize = 100
        
        return try await withCheckedThrowingContinuation { continuation in
            backendless.data.of(BYear.self).loadRelations(objectId: yearId, queryBuilder: loadRelationsQueryBuilder, responseHandler: { (response) in
                let sponsors = response as? [BSponsor] ?? []
                continuation.resume(returning: sponsors)
            }, errorHandler: { (error) in
                continuation.resume(throwing: error)
            })
        }
    }
    
    func getEvents(yearId: String) async throws -> [BEvent]? {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder(entityClass: BEvent.self, relationName: "events")
        loadRelationsQueryBuilder.pageSize = 100
        
        return try await withCheckedThrowingContinuation { continuation in
            backendless.data.of(BYear.self).loadRelations(objectId: yearId, queryBuilder: loadRelationsQueryBuilder, responseHandler: { (response) in
                let events = response as? [BEvent] ?? []
                continuation.resume(returning: events)
            }, errorHandler: { (error) in
                print("error: \(String(describing: error))")
                continuation.resume(throwing: error)
            })
        }
    }
    
    func getPapers(eventId: String) async throws -> [BPaper]? {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder(entityClass: BPaper.self, relationName: "papers")
        loadRelationsQueryBuilder.pageSize = 100
        
        return try await withCheckedThrowingContinuation { continuation in
            backendless.data.of(BEvent.self).loadRelations(objectId: eventId, queryBuilder: loadRelationsQueryBuilder, responseHandler: { (response) in
                let papers = response as? [BPaper]  ?? []
                continuation.resume(returning: papers)
            }, errorHandler: { (error) in
                continuation.resume(throwing: error)
            })
        }
    }
    
    func update(note: BNote) async throws -> BNote? {
        let saved: BNote? = try await withCheckedThrowingContinuation { continuation in
            backendless.data.of(BNote.self).save(entity: note, responseHandler: { (response) in
                continuation.resume(returning: response as? BNote)
            }, errorHandler: { (error) in
                print("error \(error.debugDescription)")
                continuation.resume(throwing: error)
            })
        }
        
        guard let saved else {
            return nil
        }
        return try await self.relate(note: saved, user: note.user)
    }
    
    func relate(note: BNote, user: BackendlessUser) async throws -> BNote? {
        return try await withCheckedThrowingContinuation { continuation in
            backendless.data.of(BNote.self).addRelation(
                columnName: "user",
                parentObjectId: note.objectId!,
                childrenObjectIds: [user.objectId!],
                responseHandler: { (response) in
                    continuation.resume(returning: note)
                }) { (error) in
                    continuation.resume(throwing: error)
                }
        }
    }
    
    func getNotes() async throws -> [BNote]? {
        guard let user = getCurrentUser() else {
            return nil
        }
        let dataQuery = DataQueryBuilder()
        dataQuery.whereClause = "user.objectId = \'\(user.objectId!)\'"
        
        return try await withCheckedThrowingContinuation { continuation in
            backendless.data.of(BNote.self).find(queryBuilder: dataQuery, responseHandler: { (response) in
                print("response \(String(describing: response))")
                let notes = response as? [BNote] ?? []
                continuation.resume(returning: notes)
            }, errorHandler: { (error) in
                print("error: \(String(describing: error))")
                continuation.resume(throwing: error)
            })
        }
    }
    
    func registerForPush(tokenData: Data) {
        backendless.messaging.registerDevice(deviceToken: tokenData, responseHandler: { (response) in
            print("registerForPush response \(String(describing: response))")
        }, errorHandler: { (error) in
            print("registerForPush error: \(String(describing: error.message))")
        })
    }
    
}
