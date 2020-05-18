//
//  DownloadImage.swift
//  Pixel
//
//  Created by Anna Zislina on 10/01/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    //MARK: Download Image func
    public func downloadImage(urlString: String, completion: ((_ errorMessage: String?) -> Void)?) {
        
        let task = URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                completion?("error")
                return
           }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.image = image
                completion?(nil)
            }
       })
        task.resume()
    }
    
}

