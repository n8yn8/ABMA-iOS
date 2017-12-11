//
//  DbManager.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 10/30/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class DbManager: NSObject {
    
    static let sharedInstance = DbManager()
    
    
    override init() {
        super.init()
    }
    
    func update(year: BYear, callback: @escaping (_ savedYear: BYear?, _ errorString: String?) -> Void) {
        
        if let objectId = year.objectId {
            NetworkExecutor.put(endpoint: .year, params: year, objectId: objectId, callback: { (year, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    callback(year, nil)
                }
            })
        } else {
            NetworkExecutor.execute(endpoint: .year, method: .post, params: year) { (year, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    callback(year, nil)
                }
            }
        }
    }
    
    func update(event: BEvent, yearParent: String, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        if let objectId = event.objectId {
            NetworkExecutor.put(endpoint: .event, params: event, objectId: objectId, callback: { (event, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    callback(event, nil)
                }
            })
        } else {
            NetworkExecutor.execute(endpoint: .event, method: .post, params: event) { (event, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    self.relate(event: event!, yearParent: yearParent, callback: callback)
                    
                }
            }
        }
    }
    
    private func relate(event: BEvent, yearParent: String, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        NetworkExecutor.addRelation(parentTable: NetworkExecutor.Endpoint.year, parentObjectId: yearParent, childObjectId: event.objectId!, relationName: "events", callback: { (object, error) in
            if let err = error {
                if err is DecodingError {
                    callback(event, nil)
                } else {
                    callback(nil, err.localizedDescription)
                }
            } else {
                callback(event, nil)
            }
        })
    }
    
    func getYears(callback: @escaping ([BYear]?, Error?) -> Void) {
        
        NetworkExecutor.execute(endpoint: .year, method: .get, callback: callback)

    }
    
    func deleteEvent(event: BEvent) {
        
    }
    
    func deleteRelatedPapers(event: BEvent, callback: @escaping () -> Void) {
        
    }
    
    func deletePaper(paper: BPaper) {
        
    }
    
    func uploadImage(name: String, image: NSData, callback: @escaping (_ imageUrl: String) -> Void) {
        
    }
    
    func pushUpdate(message: String) {
        
    }
    
}
