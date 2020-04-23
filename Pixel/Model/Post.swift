//
//  Post.swift
//  Pixel
//
//  Created by Anna Zislina on 16/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class PhotoPost {
    
    var imgDownloadURL: String?
    private var image: UIImage!
    
    init(image: UIImage) {
        self.image = image
    }
}
   // guard let image = image, let data = image.jpegData(compressionQuality: 1.0)
    
//    func save() {
//        // 1. create a new db ref
//        let newPostRef = Database.database().reference().child(Constants.Keys.photoPosts).childByAutoId()
//        let newPostKey = newPostRef.key!
//
//        if let imgData = image.jpegData(compressionQuality: 0.6) {
//            // 2. create a new storage ref
//            let imageStorageRef = Storage.storage().reference().child("images")
//            let newImgRef = imageStorageRef.child(newPostKey)
//
//            // 3. save the img to storage 1st
//            newImgRef.putData(imgData).observe(.success) { (snapshot) in
//
//            // 4. save the post cattion and download url
////                self.imgDownloadURL = snapshot.metadata?.storageReference?.downloadURL(completion: { (url, err) in
////                    if let err = err {
////                    self.presentAlert(title: "Error", message: err.localizedDescription)
////                    return
////                }
////            }
//
//        }
//
//
//
//
//
//
//
//    }
//}
