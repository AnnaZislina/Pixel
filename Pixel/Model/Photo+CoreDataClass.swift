//
//  Photo+CoreDataClass.swift
//  Pixel
//
//  Created by Anna Zislina on 27/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

@objc(Photo)
public class Photo: NSManagedObject, Codable {
    
    var dataController: DataController!
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
        case photographer
        case src
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(width, forKey: .width)
            try container.encode(height, forKey: .height)
            try container.encode(url, forKey: .url)
            try container.encode(photographer, forKey: .photographer)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Photo", in: managedObjectContext) else {
                fatalError("Failed to decode Photo") //error
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            width = try values.decode(Int16.self, forKey: .width)
            height = try values.decode(Int16.self, forKey: .height)
            url = try values.decode(String.self, forKey: .url)
            src = NSSet(array: try values.decode([Src].self, forKey: .src))
            print(src as Any)
        } catch {
            print("error")
        }
    }
    
}
