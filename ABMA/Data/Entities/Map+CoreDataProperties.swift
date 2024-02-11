//
//  Map+CoreDataProperties.swift
//  ABMA
//
//  Created by Nate Condell on 2/11/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

import Foundation
import CoreData


extension Map {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Map> {
        return NSFetchRequest<Map>(entityName: "Map")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var year: Year?

}

extension Map : Identifiable {

}
