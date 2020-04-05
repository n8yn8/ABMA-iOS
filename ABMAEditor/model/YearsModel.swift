//
//  YearsModel.swift
//  ABMAEditor
//
//  Created by Nathan Condell on 4/4/20.
//  Copyright © 2020 Nathan Condell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class YearsModel {
    static let instance = YearsModel()
    var years: [BYear] = [BYear]()
    var selectedYear: BYear? = nil
    let sponsors: BehaviorRelay<[BSponsor]> = BehaviorRelay(value: [])
}

extension YearsModel {
    func add(sponsor: BSponsor) {
        guard let thisYear = selectedYear else {
            return
        }
        if thisYear.sponsors == nil {
            thisYear.sponsors = [BSponsor]()
        }
        if let id = sponsor.objectId {
            var found = false
            for i in 0 ..< thisYear.sponsors!.count {
                let sponsor = thisYear.sponsors![i]
                if id == sponsor.objectId {
                    found = true
                    thisYear.sponsors![i] = sponsor
                }
            }
            if !found {
                thisYear.sponsors!.append(sponsor)
            }
        } else {
            thisYear.sponsors!.append(sponsor)
        }
        sponsors.accept(thisYear.sponsors!)
    }
    
    func remove(sponsor: BSponsor) {
        DbManager.sharedInstance.delete(sponsor: sponsor)
        
        if let index = selectedYear?.sponsors?.firstIndex(of: sponsor) {
            selectedYear?.sponsors?.remove(at: index)
        }
        sponsors.accept(selectedYear!.sponsors!)
        
    }
}
