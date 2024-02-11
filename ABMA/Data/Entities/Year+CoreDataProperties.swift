//
//  Year+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Year {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Year> {
        return NSFetchRequest<Year>(entityName: "Year")
    }

    @NSManaged public var bObjectId: String?
    @NSManaged public var created: Date?
    @NSManaged public var info: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var welcome: String?
    @NSManaged public var year: String?
    @NSManaged public var day: NSSet?
    @NSManaged public var maps: NSSet?
    @NSManaged public var sponsors: NSSet?
    @NSManaged public var surveys: NSSet?

}

// MARK: Generated accessors for day
extension Year {

    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: Day)

    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: Day)

    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)

}

// MARK: Generated accessors for maps
extension Year {

    @objc(addMapsObject:)
    @NSManaged public func addToMaps(_ value: Map)

    @objc(removeMapsObject:)
    @NSManaged public func removeFromMaps(_ value: Map)

    @objc(addMaps:)
    @NSManaged public func addToMaps(_ values: NSSet)

    @objc(removeMaps:)
    @NSManaged public func removeFromMaps(_ values: NSSet)

}

// MARK: Generated accessors for sponsors
extension Year {

    @objc(addSponsorsObject:)
    @NSManaged public func addToSponsors(_ value: Sponsor)

    @objc(removeSponsorsObject:)
    @NSManaged public func removeFromSponsors(_ value: Sponsor)

    @objc(addSponsors:)
    @NSManaged public func addToSponsors(_ values: NSSet)

    @objc(removeSponsors:)
    @NSManaged public func removeFromSponsors(_ values: NSSet)

}

// MARK: Generated accessors for surveys
extension Year {

    @objc(addSurveysObject:)
    @NSManaged public func addToSurveys(_ value: Survey)

    @objc(removeSurveysObject:)
    @NSManaged public func removeFromSurveys(_ value: Survey)

    @objc(addSurveys:)
    @NSManaged public func addToSurveys(_ values: NSSet)

    @objc(removeSurveys:)
    @NSManaged public func removeFromSurveys(_ values: NSSet)

}

extension Year : Identifiable {

}
