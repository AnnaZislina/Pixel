//
//  Src+CoreDataProperties.swift
//  Pixel
//
//  Created by Anna Zislina on 27/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//
//

import Foundation
import CoreData


extension Src {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Src> {
        return NSFetchRequest<Src>(entityName: "Src")
    }

    @NSManaged public var original: String?
    @NSManaged public var large: String?
    @NSManaged public var large2x: String?
    @NSManaged public var photo: Photo?

}
