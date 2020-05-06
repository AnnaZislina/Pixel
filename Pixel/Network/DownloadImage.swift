//
//  DownloadImage.swift
//  Pixel
//
//  Created by Anna Zislina on 10/01/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

extension UIImageView {
    
    public func downloadImage(urlString: String) {
        
        let task = URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
           }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.image = image
            }
       })
        task.resume()
    }
    
}
