//
//  DbManager.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 10/30/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation
import SwiftSDK

class DbManager: NSObject {
    
    static let sharedInstance = DbManager()
    
    static let applicationId = "7D06F708-89FA-DD86-FF95-C51A10425A00"
    static let apiKey = "5DB2DE1C-0AFF-9AD6-FF16-83C8AE9F1600"
    
    enum FileType : String {
        case sponsor = "sponsor", map = "map"
    }
    
    override init() {
        super.init()
        Backendless.shared.initApp(applicationId: DbManager.applicationId, apiKey: DbManager.apiKey)
    }
    
    func handleResponse<T : Codable>(response: Any, callback: @escaping (T?, String?) -> Void) {
        if let objects = response as? T {
            callback(objects, nil)
        } else {
            callback(nil, nil)
        }
    }
    
    func update(year: BYear, callback: @escaping (BYear?, String?) -> Void) {
        Backendless.shared.data.of(BYear.self).save(entity: year, responseHandler: { (response) in
            self.handleResponse(response: response, callback: callback)
        }) { (error) in
            callback(nil, error.message)
        }
    }
    
    func update(event: BEvent, yearParent: String, callback: @escaping (_ savedEvent: BEvent?, _ errorString: String?) -> Void) {
        Backendless.shared.data.of(BEvent.self).save(entity: event, responseHandler: { (response) in
            if event.objectId == nil {
                self.relate(event: response as! BEvent, yearParent: yearParent, callback: callback)
            } else {
                self.handleResponse(response: response, callback: callback)
            }
        }) { (error) in
            callback(nil, error.message)
        }
    }
    
    func update(paper: BPaper, eventParent: String, callback: @escaping (_ savedPaper: BPaper?, _ errorString: String?) -> Void) {
        Backendless.shared.data.of(BPaper.self).save(entity: paper, responseHandler: { (response) in
            if paper.objectId == nil {
                self.relate(paper: response as! BPaper, eventParent: eventParent, callback: callback)
            } else {
                self.handleResponse(response: response, callback: callback)
            }
        }) { (error) in
            callback(nil, error.message)
        }
    }
    
    func update(sponsor: BSponsor, yearParent: String, callback: @escaping (_ savedSponsor: BSponsor?, _ errorString: String?) -> Void) {
        Backendless.shared.data.of(BSponsor.self).save(entity: sponsor, responseHandler: { (response) in
            if sponsor.objectId == nil {
                self.relate(sponsor: response as! BSponsor, yearParent: yearParent, callback: callback)
            } else {
                self.handleResponse(response: response, callback: callback)
            }
        }) { (error) in
            callback(nil, error.message)
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
        loadRelationsQueryBuilder.pageSize = 100
        
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
        
        Backendless.shared.data.of(BEvent.self).remove(entity: event, responseHandler: { (responseCount) in
            print("deleted = \(String(describing: event))")
        }) { (error) in
            print("deletePaper error = \(String(describing: error))")
        }
    }
    
    func delete(paper: BPaper) {
        Backendless.shared.data.of(BPaper.self).remove(entity: paper, responseHandler: { (responseCount) in
            print("deleted = \(String(describing: paper))")
        }) { (error) in
            print("deletePaper error = \(String(describing: error))")
        }
    }
    
    func delete(sponsor: BSponsor) {
        Backendless.shared.data.of(BSponsor.self).remove(entity: sponsor, responseHandler: { (responseCount) in
            print("deleted = \(String(describing: sponsor))")
        }) { (error) in
            print("deletePaper error = \(String(describing: error))")
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
    
    private func delete(fileUrl: String, fileType: DbManager.FileType) {
        let parts = fileUrl.components(separatedBy: "/")
        if let fileName = parts.last {
            Backendless.shared.file.remove(path: "\(fileType.rawValue)/\(fileName)", responseHandler: {_ in
                print("deleteFile success = \(fileName)")
            }) { (error) in
                print("deleteFile error = \(String(describing: error))")
            }
        }
    }
    
    func uploadSponsorImage(name: String, image: Data, callback: @escaping (String?, Error?) -> Void) {
        Backendless.shared.file.uploadFile(fileName: name, filePath: "sponsor", content: image, overwrite: true, responseHandler: { (backendlessFile) in
            callback(backendlessFile.fileUrl, nil)
        }) { (fault) in
            callback(nil, fault)
        }
    }
    
    func uploadMapImage(name: String, image: Data, callback: @escaping (String?, Error?) -> Void) {
        Backendless.shared.file.uploadFile(fileName: name, filePath: "map", content: image, overwrite: true, responseHandler: { (backendlessFile) in
                    callback(backendlessFile.fileUrl, nil)
                }) { (fault) in
                    callback(nil, fault)
                }
    }
    
    func pushUpdate(message: String) {
        let title = "ABMA"
        let text = "ABMA Update"
        guard let headers = try? PushHeaders(androidTitle: title, androidText: text, iosTitle: title, iosText: message, iosContentAvail: "true").asDictionary() else {
            print("pushUpdate convert to dict failed")
            return
        }
        
        let publishOptions = PublishOptions()
        publishOptions.headers = headers

        let deliveryOptions = DeliveryOptions()
        deliveryOptions.pushBroadcast = PushBroadcastEnum.FOR_IOS.rawValue | PushBroadcastEnum.FOR_ANDROID.rawValue
        
        Backendless.shared.messaging.publish(channelName: "default", message: message, publishOptions: publishOptions, deliveryOptions: deliveryOptions, responseHandler: { messageStatus in
            print("Message status: \(messageStatus)")
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
    }
    
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
