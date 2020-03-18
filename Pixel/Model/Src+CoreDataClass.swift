//
//  Src+CoreDataClass.swift
//  Pixel
//
//  Created by Anna Zislina on 27/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Src)
public class Src: NSManagedObject, Codable {
    
    var dataController: DataController!
    
    enum CodingKeys: String, CodingKey {
        case original
        case large
        case larde2x
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(original, forKey: .original)
            try container.encode(large, forKey: .large)
            try container.encode(large2x, forKey: .larde2x)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Src", in: managedObjectContext) else {
                fatalError("Failed to decode Src")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            original = try values.decode(String.self, forKey: .original)
            large = try values.decode(String.self, forKey: .large)
            large2x = try values.decode(String.self, forKey: .larde2x)
        } catch {
            print("error")
        }
    }

}
