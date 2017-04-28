//
//  BEvent.swift
//  ABMA
//
//  Created by Nathan Condell on 1/3/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class BEvent: NSObject {
    
    var objectId: String?
    var details: String?
    var endDate: Date?
    var location: String?
    var startDate: Date!
    var subtitle: String?
    var title: String?
    var papers = [BPaper]()
    var upadted: Date?
    var created: Date?
    
    func initWith(startDate: Date, endDate: Date, title: String) {
        
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
    }
    
    func doSort() {
        let sortedPapers = papers.sorted(by: { (paper1, paper2) -> Bool in
            paper1.order < paper2.order
        })
        papers = sortedPapers
    }
}
