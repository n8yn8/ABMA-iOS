//
//  Survey+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Survey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Survey> {
        return NSFetchRequest<Survey>(entityName: "Survey")
    }

    @NSManaged public var details: String?
    @NSManaged public var end: Date?
    @NSManaged public var start: Date?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var year: Year?

}

extension Survey : Identifiable {

}
