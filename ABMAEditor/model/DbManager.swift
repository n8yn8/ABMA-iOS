//
//  DbManager.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 10/30/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation
import Backendless

class DbManager: NSObject {
    
    static let sharedInstance = DbManager()
    
    static let applicationId = "76269ABA-AF2E-5901-FF61-99AB83F57700"
    static let apiKey = "F7225E47-B7A7-487D-91AD-0DAF47C8AD17"
    
    
    override init() {
        super.init()
        Backendless.shared.initApp(applicationId: DbManager.applicationId, apiKey: NetworkExecutor.restKey)
    }
    
    func handleResponse<T : Codable>(response: Any, callback: @escaping (T?, String?) -> Void) {
        if let objects = response as? T {
            callback(objects, nil)
        } else {
            callback(nil, nil)
        }
    }
    
    func update(year: BYear, callback: @escaping (BYear?, String?) -> Void) {
        Backendless.shared.data.of(BYear.self).create(entity: year, responseHandler: { (response) in
            self.handleResponse(response: response, callback: callback)
        }) { (error) in
            callback(nil, error.message)
        }
    }
    
    func update(event: BEvent, yearParent: String, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        if event.objectId != nil {
            Backendless.shared.data.of(BEvent.self).update(entity: event, responseHandler: { (response) in
                self.handleResponse(response: response, callback: callback)
            }) { (error) in
                callback(nil, error.message)
            }
        } else {
            Backendless.shared.data.of(BEvent.self).create(entity: event, responseHandler: { (response) in
                self.relate(event: response as! BEvent, yearParent: yearParent, callback: callback)
            }) { (error) in
                callback(nil, error.message)
            }
        }
    }
    
    func update(paper: BPaper, eventParent: String, callback: @escaping (_ savedPaper: BPaper?, _ errorString: String?) -> Void) {
        if paper.objectId != nil {
            Backendless.shared.data.of(BPaper.self).update(entity: paper, responseHandler: { (response) in
                self.handleResponse(response: response, callback: callback)
            }) { (error) in
                callback(nil, error.message)
            }
        } else {
            Backendless.shared.data.of(BPaper.self).create(entity: paper, responseHandler: { (response) in
                self.relate(paper: response as! BPaper, eventParent: eventParent, callback: callback)
            }) { (error) in
                callback(nil, error.message)
            }
        }
    }
    
    func update(sponsor: BSponsor, yearParent: String, callback: @escaping (_ savedSponsor: BSponsor?, _ errorString: String?) -> Void) {
        if sponsor.objectId != nil {
            Backendless.shared.data.of(BSponsor.self).update(entity: sponsor, responseHandler: { (response) in
                self.handleResponse(response: response, callback: callback)
            }) { (error) in
                callback(nil, error.message)
            }
        } else {
            Backendless.shared.data.of(BSponsor.self).create(entity: sponsor, responseHandler: { (response) in
                self.relate(sponsor: response as! BSponsor, yearParent: yearParent, callback: callback)
            }) { (error) in
                callback(nil, error.message)
            }
        }
    }
    
    private func relate(event: BEvent, yearParent: String, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        Backendless.shared.data.of(BYear.self).addRelation(columnName: "events", parentObjectId: yearParent, childrenObjectIds: [event.objectId!], responseHandler: { (response) in
            callback(event, nil)
        }) { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        }
    }
    
    private func relate(paper: BPaper, eventParent: String, callback: @escaping (_ savedPaper: BPaper?, _ errorString: String?) -> Void) {
        Backendless.shared.data.of(BEvent.self).addRelation(columnName: "papers", parentObjectId: eventParent, childrenObjectIds: [paper.objectId!], responseHandler: { (response) in
            callback(paper, nil)
        }) { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        }
    }
    
    private func relate(sponsor: BSponsor, yearParent: String, callback: @escaping (_ savedSponsor: BSponsor?, _ errorString: String?) -> Void) {
        Backendless.shared.data.of(BYear.self).addRelation(columnName: "sponsors", parentObjectId: yearParent, childrenObjectIds: [sponsor.objectId!], responseHandler: { (response) in
            callback(sponsor, nil)
        }) { (error) in
            print("error \(error.debugDescription)")
            callback(nil, error.debugDescription)
        }
    }
    
    func getYears(callback: @escaping ([BYear]?, Error?) -> Void) {
        Backendless.shared.data.of(BYear.self).find(responseHandler: { (response) in
            print("response \(String(describing: response))")
            self.handleResponse(response: response, callback: callback)
        }, errorHandler: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error)
        })

    }
    
    func getRelated<T : Codable>(relationName: String, parentId: String, parentClass: AnyClass, callback: @escaping ([T]?, Error?) -> Void) {
        let loadRelationsQueryBuilder = LoadRelationsQueryBuilder(entityClass: T.self, relationName: relationName)
        loadRelationsQueryBuilder.setPageSize(pageSize: 100)
        
        Backendless.shared.data.of(parentClass).loadRelations(objectId: parentId, queryBuilder: loadRelationsQueryBuilder, responseHandler: { (response) in
            self.handleResponse(response: response, callback: callback)
        }, errorHandler: { (error) in
            print("error: \(String(describing: error))")
            callback(nil, error)
        })
    }
    
    func handleResponse<T : Codable>(response: Any, callback: @escaping ([T]?, Error?) -> Void) {
        if let objects = response as? [T] {
            callback(objects, nil)
        } else {
            callback([T](), nil)
        }
    }
    
    func getSponsors(parentId: String, callback: @escaping ([BSponsor]?, Error?) -> Void) {
        getRelatedToYear(relationName: "sponsors", parentId: parentId, callback: callback)
    }
    
    func getEvents(parentId: String, callback: @escaping ([BEvent]?, Error?) -> Void) {
        getRelatedToYear(relationName: "events", parentId: parentId, callback: callback)
    }
    
    func getRelatedToYear<T : Codable>(relationName: String, parentId: String, callback: @escaping ([T]?, Error?) -> Void) {
        getRelated(relationName: relationName, parentId: parentId, parentClass: BYear.self, callback: callback)
    }
    
    func getPapers(parentId: String, callback: @escaping ([BPaper]?, Error?) -> Void) {
        getRelated(relationName: "papers", parentId: parentId, parentClass: BEvent.self, callback: callback)
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
            delete(fileUrl: url, fileType: .sponsor)
        }
    }
    
    func delete(map: BMap) {
        if let url = map.url {
            delete(fileUrl: url, fileType: .map)
        }
    }
    
    private func delete(fileUrl: String, fileType: NetworkExecutor.FileType) {
        let parts = fileUrl.components(separatedBy: "/")
        if let fileName = parts.last {
            NetworkExecutor.delete(fileName: fileName, fileType: fileType) { (response, error) in
                print("deleteFile error = \(String(describing: error))")
            }
        }
    }
    
    func uploadSponsorImage(name: String, image: NSData, callback: @escaping (String?, Error?) -> Void) {
        NetworkExecutor.upload(fileName: name, image: image, fileType: .sponsor, callback: callback)
    }
    
    func uploadMapImage(name: String, image: NSData, callback: @escaping (String?, Error?) -> Void) {
        NetworkExecutor.upload(fileName: name, image: image, fileType: .map, callback: callback)
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
