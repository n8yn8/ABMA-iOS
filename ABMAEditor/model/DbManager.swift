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
    
    let appId = "627F9018-4483-B50E-FFCA-0E42A1E33F00"
    let restKey = "16CA6717-731C-8523-FFFD-AC9B1A0AD600"
    
    override init() {
        super.init()
    }
    
    func registerUser(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        
    }
    
    func login(email: String, password: String, callback: @escaping (_ errorString: String?) -> Void) {
        
    }
    
    func update(year: BYear, callback: @escaping (_ savedYear: BYear?, _ errorString: String?) -> Void) {
        
    }
    
    func updateEvent(event: BEvent, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        
    }
    
    func getYears(callback: @escaping ([BYear]?, Error?) -> Void) {

        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/data/BYear") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // Make request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // handle response to request
            // check for error
            guard error == nil else {
                DispatchQueue.main.async {
                    callback(nil, error!)
                }
                return
            }
            // make sure we got data in the response
            guard let responseData = data else {
                print("Error: did not receive data")
                let error = BackendError.objectSerialization(reason: "No data in response")
                DispatchQueue.main.async {
                    callback(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let year = try decoder.decode([BYear].self, from: responseData)
                DispatchQueue.main.async {
                    callback(year, nil)
                }
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                DispatchQueue.main.async {
                    callback(nil, error)
                }
            }
        })
        task.resume()
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
