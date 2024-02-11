//
//  Day+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date?
    @NSManaged public var event: NSSet?
    @NSManaged public var year: Year?

}

// MARK: Generated accessors for event
extension Day {

    @objc(addEventObject:)
    @NSManaged public func addToEvent(_ value: Event)

    @objc(removeEventObject:)
    @NSManaged public func removeFromEvent(_ value: Event)

    @objc(addEvent:)
    @NSManaged public func addToEvent(_ values: NSSet)

    @objc(removeEvent:)
    @NSManaged public func removeFromEvent(_ values: NSSet)

}

extension Day : Identifiable {

}
