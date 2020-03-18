//
//  Photo+CoreDataProperties.swift
//  Pixel
//
//  Created by Anna Zislina on 27/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    @NSManaged public var url: String?
    @NSManaged public var photographer: String?
    @NSManaged public var src: NSSet?

}

// MARK: Generated accessors for src
extension Photo {

    @objc(addSrcObject:)
    @NSManaged public func addToSrc(_ value: Src)

    @objc(removeSrcObject:)
    @NSManaged public func removeFromSrc(_ value: Src)

    @objc(addSrc:)
    @NSManaged public func addToSrc(_ values: NSSet)

    @objc(removeSrc:)
    @NSManaged public func removeFromSrc(_ values: NSSet)

}
