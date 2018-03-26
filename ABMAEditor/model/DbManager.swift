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
    
    func update(paper: BPaper, eventParent: String, callback: @escaping (_ savedPaper: BPaper?, _ errorString: String?) -> Void) {
        if let objectId = paper.objectId {
            NetworkExecutor.put(endpoint: .paper, params: paper, objectId: objectId, callback: { (savedPaper, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    callback(savedPaper, nil)
                }
            })
        } else {
            NetworkExecutor.execute(endpoint: .paper, method: .post, params: paper) { (savedPaper, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    self.relate(paper: savedPaper!, eventParent: eventParent, callback: callback)
                    
                }
            }
        }
    }
    
    func update(sponsor: BSponsor, yearParent: String, callback: @escaping (_ savedSponsor: BSponsor?, _ errorString: String?) -> Void) {
        if let objectId = sponsor.objectId {
            NetworkExecutor.put(endpoint: .sponsor, params: sponsor, objectId: objectId, callback: { (savedSponsor, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    callback(savedSponsor, nil)
                }
            })
        } else {
            NetworkExecutor.execute(endpoint: .sponsor, method: .post, params: sponsor) { (savedSponsor, error) in
                if let err = error {
                    callback(nil, err.localizedDescription)
                } else {
                    self.relate(sponsor: savedSponsor!, yearParent: yearParent, callback: callback)
                    
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
    
    private func relate(paper: BPaper, eventParent: String, callback: @escaping (_ savedPaper: BPaper?, _ errorString: String?) -> Void) {
        NetworkExecutor.addRelation(parentTable: NetworkExecutor.Endpoint.event, parentObjectId: eventParent, childObjectId: paper.objectId!, relationName: "papers", callback: { (object, error) in
            if let err = error {
                if err is DecodingError {
                    callback(paper, nil)
                } else {
                    callback(nil, err.localizedDescription)
                }
            } else {
                callback(paper, nil)
            }
        })
    }
    
    private func relate(sponsor: BSponsor, yearParent: String, callback: @escaping (_ savedSponsor: BSponsor?, _ errorString: String?) -> Void) {
        NetworkExecutor.addRelation(parentTable: NetworkExecutor.Endpoint.year, parentObjectId: yearParent, childObjectId: sponsor.objectId!, relationName: "sponsors", callback: { (object, error) in
            if let err = error {
                if err is DecodingError {
                    callback(sponsor, nil)
                } else {
                    callback(nil, err.localizedDescription)
                }
            } else {
                callback(sponsor, nil)
            }
        })
    }
    
    func getYears(callback: @escaping ([BYear]?, Error?) -> Void) {
        
        NetworkExecutor.execute(endpoint: .year, method: .get, callback: callback)

    }
    
    func getSponsors(parentId: String, callback: @escaping ([BSponsor]?, Error?) -> Void) {
        NetworkExecutor.getRelated(parentId: parentId, relationName: "sponsors", endpoint: .year, callback: callback)
    }
    
    func getEvents(parentId: String, callback: @escaping ([BEvent]?, Error?) -> Void) {
        NetworkExecutor.getRelated(parentId: parentId, relationName: "events", endpoint: .year, callback: callback)
    }
    
    func getPapers(parentId: String, callback: @escaping ([BPaper]?, Error?) -> Void) {
        NetworkExecutor.getRelated(parentId: parentId, relationName: "papers", endpoint: .event, callback: callback)
    }
    
    func delete(event: BEvent) {
        if let papers = event.papers {
            for paper in papers {
                delete(paper: paper)
            }
        }
        
        NetworkExecutor.delete(objectId: event.objectId!, endpoint: .event) { (response, error) in
            print("deleteEvent error = \(String(describing: error))")
        }
    }
    
    func delete(paper: BPaper) {
        NetworkExecutor.delete(objectId: paper.objectId!, endpoint: .paper) { (response, error) in
            print("deletePaper error = \(String(describing: error))")
        }
    }
    
    func delete(sponsor: BSponsor) {
        NetworkExecutor.delete(objectId: sponsor.objectId!, endpoint: .sponsor) { (response, error) in
            print("deleteSponsor error = \(String(describing: error))")
        }
        if let url = sponsor.imageUrl {
            delete(fileUrl: url)
        }
    }
    
    private func delete(fileUrl: String) {
        let parts = fileUrl.components(separatedBy: "/")
        if let fileName = parts.last {
            NetworkExecutor.delete(fileName: fileName) { (response, error) in
                print("deleteFile error = \(String(describing: error))")
            }
        }
    }
    
    func uploadImage(name: String, image: NSData, callback: @escaping (String?, Error?) -> Void) {
        NetworkExecutor.upload(fileName: name, image: image, callback: callback)
    }
    
    func pushUpdate(message: String) {
        let title = "ABMA"
        let text = "ABMA Update"
        let headers = PushHeaders(androidTitle: title, androidText: text, iosTitle: title, iosText: message, iosContentAvail: "true")
        let params = PushParams(message: message, pushPolicy: "PUSH", headers: headers)
        
        NetworkExecutor.pushNotification(params: params) { (success, error) in
            print("Push success \(String(describing: success))")
            print("Push error \(String(describing: error))")
        }
    }
    
}
