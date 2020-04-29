//
//  Data.swift
//  Pixel
//
//  Created by Anna Zislina on 28/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation
import UIKit

class Image: Codable {
    var imageData: Data?
    
    init(imageData: Data) {
        self.imageData = imageData
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Image").appendingPathExtension("plist")
    
    static func loadImages() -> [Image]? {
        guard let codedImages = try? Data(contentsOf: ArchiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Image>.self, from: codedImages)
    }
    
    static func loadSampleImages() -> [Image] {
        return []
    }
    
    static func saveImages(_ images: [Image]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedImages = try? propertyListEncoder.encode(images)
        try? codedImages?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func removeImages() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("diskCache")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    

}
