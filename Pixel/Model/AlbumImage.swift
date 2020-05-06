//
//  AlbumImage.swift
//  Pixel
//
//  Created by Anna Zislina on 28/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation
import UIKit

class AlbumImage: Codable {
    
    // The raw data of the image
    var imageData: Data?
    
    init(imageData: Data) {
        self.imageData = imageData
    }
    
    // The local URL of the image
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // The URL of the image
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Image").appendingPathExtension("plist")
    
    static func loadImages() -> [AlbumImage]? {
        guard let codedImages = try? Data(contentsOf: ArchiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<AlbumImage>.self, from: codedImages)
    }
    
    static func loadSampleImages() -> [AlbumImage] {
        return []
    }
    
    static func saveImages(_ images: [AlbumImage]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedImages = try? propertyListEncoder.encode(images)
        try? codedImages?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func removeImage(_ imageToDelete: AlbumImage) {

        //Call loadImages to get all the currently persisted images
        let imagesLoaded = AlbumImage.loadImages()
        
        //Copy the images different from the one we want to delete to another array
        var imagesToSave = [AlbumImage]()

        //Call saveImages with new array that includes all images except the one we want to delete
        for image in imagesLoaded ?? [] {
     
            if image.imageData != imageToDelete.imageData {
                imagesToSave.append(image)
            }
        }
        AlbumImage.saveImages(imagesToSave)
    }

}
