//
//  BEvent.swift
//  ABMA
//
//  Created by Nathan Condell on 1/3/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class BEvent: NSObject, Codable {
    
    @objc var objectId: String?
    @objc var details: String?
    @objc var endDate: Date?
    @objc var location: String?
    @objc var startDate: Date!
    @objc var subtitle: String?
    @objc var title: String?
    @objc var papers: [BPaper]?
    @objc var papersCount = 0
    @objc var upadted: Date?
    @objc var created: Date?
    
    @objc
    func initWith(startDate: Date, endDate: Date, title: String) {
        
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
    }
    
    @objc 
    func doSort() {
        guard let thesePapers = papers else {
            return
        }
        let sortedPapers = thesePapers.sorted(by: { (paper1, paper2) -> Bool in
            paper1.order < paper2.order
        })
        papers = sortedPapers
    }
}
