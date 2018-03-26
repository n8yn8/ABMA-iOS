//
//  NetworkExecuter.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 11/7/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class NetworkExecutor {
    
    static let appId = "7D06F708-89FA-DD86-FF95-C51A10425A00"
    static let restKey = "B33AA35D-DC43-EF5D-FF7A-7473FADBE400"
    
    enum Endpoint : String {
        case year = "BYear", event = "BEvent", paper = "BPaper", sponsor = "BSponsor"
    }
    
    enum Method : String {
        case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
    }
    
    static func getRelated<T : Codable>(parentId: String, relationName: String, endpoint: Endpoint, callback: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/data/\(endpoint.rawValue)/\(parentId)/\(relationName)?pageSize=100&offset=0&relationsDepth=2") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        execute(method: .get, paramsData: nil, url: url, callback: callback)
    }
    
    static func execute<T : Codable>(endpoint: Endpoint, method: Method, callback: @escaping (T?, Error?) -> Void) {
        execute(endpoint: endpoint, method: method, params: nil, callback: callback)
    }
    
    static func delete(objectId: String, endpoint: Endpoint, callback: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/data/\(endpoint.rawValue)/\(objectId)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        execute(method: .delete, paramsData: nil, url: url, callback: callback)
    }
    
    static func delete(fileName: String,  callback: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/files/sponsors/\(fileName)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        execute(method: .delete, paramsData: nil, url: url, callback: callback)
    }
    
    static func execute<T : Codable>(endpoint: Endpoint, method: Method, params: T?, callback: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/data/\(endpoint.rawValue)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        var paramsData: Data?
        do {
            try paramsData = getParamsData(params: params)
        } catch {
            print("error trying to convert object to data")
            print(error)
            DispatchQueue.main.async {
                callback(nil, error)
            }
        }
        execute(method: method, paramsData: paramsData, url: url, callback: callback)
    }
    
    static func pushNotification(params: PushParams, callback: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/messaging/default") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        var paramsData: Data?
        do {
            try paramsData = getParamsData(params: params)
        } catch {
            print("error trying to convert object to data")
            print(error)
            DispatchQueue.main.async {
                callback(nil, error)
            }
        }
        execute(method: .post, paramsData: paramsData, url: url, callback: callback)
    }
    
    static func put<T : Codable>(endpoint: Endpoint, params: T?, objectId: String, callback: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/data/\(endpoint.rawValue)/\(objectId)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        var paramsData: Data?
        do {
            try paramsData = getParamsData(params: params)
        } catch {
            print("error trying to convert object to data")
            print(error)
            DispatchQueue.main.async {
                callback(nil, error)
            }
        }
        execute(method: .put, paramsData: paramsData, url: url, callback: callback)
    }
    
    static func addRelation(parentTable: Endpoint, parentObjectId: String, childObjectId: String, relationName: String, callback: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/data/\(parentTable.rawValue)/\(parentObjectId)/\(relationName)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        var params: Data?
        do {
            try params = getParamsData(params: [childObjectId])
        } catch {
            print("error trying to convert object to data")
            print(error)
            DispatchQueue.main.async {
                callback(nil, error)
            }
        }
        execute(method: .put, paramsData: params, url: url, callback: callback)
        
    }
    
    private static func getParamsData<T : Codable>(params: T?) throws -> Data? {
        guard let parameters = params else {
            return nil
        }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        let object = try encoder.encode(parameters)
        return object
    }
    
    private static func getParamsData<T : Codable>(params: [T]?) throws -> Data? {
        guard let parameters = params else {
            return nil
        }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        let object = try encoder.encode(parameters)
        return object
    }
    
    static func upload(fileName: String, image: NSData, callback: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://api.backendless.com/\(appId)/\(restKey)/files/sponsors/\(fileName)?overwrite=true") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            callback(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        
        let fname = "test.png"
        let mimetype = "image/png"
        
        //define the data post parameter
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(Data(referencing: image))
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        urlRequest.httpBody = body
        
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
            decoder.dateDecodingStrategy = .millisecondsSince1970
            do {
                let object = try decoder.decode(Dictionary<String, String>.self, from: responseData)
                let imageUrl = object["fileURL"] //nil if error
                var error: BackendError?
                if let errorMessage = object["message"] {
                    error = BackendError.objectSerialization(reason: errorMessage)
                }
                DispatchQueue.main.async {
                    callback(imageUrl, error)
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
    
    static func execute<T : Codable>(method: Method, paramsData: Data?, url: URL, callback: @escaping (T?, Error?) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        urlRequest.httpBody = paramsData
        
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
            decoder.dateDecodingStrategy = .millisecondsSince1970
            do {
                let object = try decoder.decode(T.self, from: responseData)
                DispatchQueue.main.async {
                    callback(object, nil)
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
}
