//
//  Paper+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Paper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paper> {
        return NSFetchRequest<Paper>(entityName: "Paper")
    }

    @NSManaged public var abstract: String?
    @NSManaged public var author: String?
    @NSManaged public var bObjectId: String?
    @NSManaged public var created: Date?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var event: Event?
    @NSManaged public var note: Note?

}

extension Paper : Identifiable {

}
