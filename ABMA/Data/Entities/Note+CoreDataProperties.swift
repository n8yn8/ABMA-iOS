//
//  Note+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var bObjectId: String?
    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var event: Event?
    @NSManaged public var paper: Paper?

}

extension Note : Identifiable {

}
