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
    
    func updateEvent(event: BEvent, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        
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
