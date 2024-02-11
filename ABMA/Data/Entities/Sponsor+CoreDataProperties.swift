//
//  Sponsor+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Sponsor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sponsor> {
        return NSFetchRequest<Sponsor>(entityName: "Sponsor")
    }

    @NSManaged public var bObjectId: String?
    @NSManaged public var created: Date?
    @NSManaged public var imageUrl: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: String?
    @NSManaged public var year: Year?

}

extension Sponsor : Identifiable {

}
