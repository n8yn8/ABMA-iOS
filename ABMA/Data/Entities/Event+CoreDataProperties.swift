//
//  Event+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var bObjectId: String?
    @NSManaged public var created: Date?
    @NSManaged public var details: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var locatoin: String?
    @NSManaged public var place: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var day: Day?
    @NSManaged public var note: Note?
    @NSManaged public var papers: NSSet?

}

// MARK: Generated accessors for papers
extension Event {

    @objc(addPapersObject:)
    @NSManaged public func addToPapers(_ value: Paper)

    @objc(removePapersObject:)
    @NSManaged public func removeFromPapers(_ value: Paper)

    @objc(addPapers:)
    @NSManaged public func addToPapers(_ values: NSSet)

    @objc(removePapers:)
    @NSManaged public func removeFromPapers(_ values: NSSet)

}

extension Event : Identifiable {

}
